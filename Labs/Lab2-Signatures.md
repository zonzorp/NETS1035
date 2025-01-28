# Digital Signatures
In this research activity, we will create a signing key pair and certificate and use it to sign, then verify, a document. To see what happens when signatures are involved, we will do everything from the command line, as opposed to importing a certificate and key from a real CA into some graphical tool for managing signed documents. This will also keep our activities free.

## Keypair and Certificate Creation
For a signature to be useful, your public key must be available from a trusted source to anyone trying to verify your signatures. Since that is more involved than we want for a lab activity, we will take advantage of having a private CA already installed on our lab VM.

1. Create a keypair and certificate for signing using the existing private CA
```bash
sudo bash
cd /etc/openvpn/easy-rsa
./easyrsa build-client-full "Your Name For Signatures"
cp pki/*/"Your Name For Signatures."* ~student/
chown student ~student/"Your Name For Signatures."*
exit
```

1. In your home directory you now have 3 files related to signing, a certificate, a private key, and the leftover CSR req file - examine them
```bash
# Examine the private key file first
openssl pkey -in ~/"Your Name For Signatures.key" -text
# Examine the certificate file
openssl x509 -in ~/"Your Name For Signatures.crt" -text
```

## Creating Signatures
We will now create a trivial document to sign. Any file can be signed as long as it has some content.

1. Create a document to sign
```bash
echo "Hello World" > ~/helloworld.txt
```

1. Create a SHA256 hash for the document
```bash
openssl dgst -sha256 ~/helloworld.txt > ~/helloworld-sha256-dgst
```

1. Use the private key to sign your hash
```bash
openssl pkeyutl -sign -inkey ~/"Your Name For Signatures.key" -in ~/helloworld.txt -out ~/helloworld-signature
```

You could now provide the helloworld.txt file along with the helloworld-signature file to someone, and they could use your public key to verify your signature is valid, and that the signature applies to the hellworld.txt file.

## Signature Verification
We can verify the signature on a file is the right one and we can verify that the signature is for the document it claims to sign.

1. Verify that the signature is valid and that the document is signed by that signature
```bash
openssl pkeyutl -verify -inkey ~/"Your Name For Signatures.crt" -certin -sigfile ~/helloworld-signature -in helloworld.txt
```

If you use a real CA-signed signing certificate, you can use this to sign any document in a way that anyone can verify the document was signed by you, and is unaltered since you signed it.

## Time Stamping
We can submit a time stamping request to a TSA and include the reply with our document to attach a non-repudiation timestamp to the document. To create our own TSA, we can use the private CA we have but the easyrsa program that manages it doesn't know about time stamp authority certificates. So we have to monkey about behind its back a bit.

### Create the necessary authority credentials to do TSA work - this is underhanded
1. Create a TSA keypair and certificate and view the created TSA certificate to verify it can be used for timeStamping
   * this only gets done once
   * it sets up the TSA
   * it would be done by an organization that is going to issue timestamps
```bash
# we need root for this
sudo bash
# save ourselves from typing out pathnames over and over
cd /etc/openvpn/easy-rsa
# Create a request for certificate for our TSA
openssl req -newkey rsa:4096 -keyout pki/private/tsa.key -out pki/reqs/tsa.req -subj="/C=CA/ST=Ontario/L=Barrie/O=NETS1035 Applied Crypto Nerds/CN=tsasrv.tsacorp.com"
# Create the nod for our certificate, because a nod's as good as a wink to a blind bat, eh?
echo "extendedKeyUsage = critical,timeStamping" > pki/extKeyUsage.cnf
# Use the nod to make a TSA certificate, sneakily updating the easyrsa serial number because of the demoCA link we already made
sudo openssl x509 -req -days 730 -in pki/reqs/tsa.req -CA pki/ca.crt -CAkey pki/private/ca.key -set_serial 01 -extfile pki/extKeyUsage.cnf -out pki/issued/tsa.crt
# View the created certificate to see that it is indeed usable for timestamping
openssl x509 -in pki/issued/tsa.crt -text -noout
# get out of the root shell, we've done enough underhanded work for today
exit
```

### Obtain a time stamp from our TSA
1. Create a time stamp request
   * we will request a timestamp for our document's signature because we have no desire to send our original document to the TSA
   * we want the timestamp to apply to our signature for the document, not to the original document
```bash
openssl ts -query -cert -out ~/ts-request.tsq -data ~/helloworld-signature
```

1. View the time stamp request to see what got put into it
```bash
openssl ts -query -in ~/ts-request.tsq -text
```

1. Assume the role of the TSA and use their credentials to sign your time stamp request
   * you would normally have sent your tsr to the TSA
   * they would do this step and send you back your time stamp reply
```bash
# Cover for a limitation in the standard openssl program's x509 subcommand
mkdir ~/demoCA
ln -s /etc/openvpn/easy-rsa/pki/serial demoCA/tsaserial
# Timestamp and sign the request
sudo openssl ts -reply -queryfile ~/ts-request.tsq -inkey /etc/openvpn/easy-rsa/pki/private/tsa.key -signer /etc/openvpn/easy-rsa/pki/issued/tsa.crt -chain /etc/openvpn/easy-rsa/pki/ca.crt >~/ts-reply.tsr
```

1. Verify the timestamp for our signature
   * this would be done by whoever want to validate our signature on a document
   * they need to be in possession of the original document, our signature, and the TSA signature for our signature
   * once they validate the timestamp for the signature, they can use the signature to validate the original document as of the date and time on our signature
```bash
# Validate hash was signed by TSA
sudo openssl ts -verify -data helloworld-signature -in ts-reply.tsr -CAfile /etc/openvpn/easy-rsa/pki/ca.crt
# Extract date and time info from timestamp signature
openssl ts -reply -in ts-reply.tsr -text -token_out
# Verify our signature against the original document
openssl pkeyutl -verify -inkey ~/"Your Name For Signatures.crt" -certin -sigfile ~/helloworld-signature -in helloworld.txt
# If this all pans out, the user now knows that the document was signed by us on the date and time claimed by the TSA signature
```

## Grading
Submit a single PDF document showing screenshots of, or copy/pasted output from, running the following sequence of commands after the lab is completed. Be sure to include your commands showing the bash prompts, so I know which submission is done by whom.
```bash
cat ~/helloworld.txt
openssl x509 -in ~/"Your Name For Signatures.crt" -text
cat ~/helloworld-signature
openssl ts -query -in ~/ts-request.tsq -text
sudo openssl ts -verify -data helloworld-signature -in ts-reply.tsr -CAfile /etc/openvpn/easy-rsa/pki/ca.crt
openssl ts -reply -in ts-reply.tsr -text -token_out
openssl pkeyutl -verify -inkey ~/"Your Name For Signatures.crt" -certin -sigfile ~/helloworld-signature -in helloworld.txt
```
