# PKI Certificates
This research activity is intended to give you familiarity with certificate related activities. It is not graded and there is nothing to submit for this lab.

## Create a self-signed certificate
1. Make up a website domain name to create a certificate for (a FQDN like abc.def.com, not just hostname) *Don't use the name of a real website*
1. Make up and use any organizational identification you like
1. Copy the private key file you generated in the previous lab that created an Ed25519 private key to a more appropriately named file with appropriate permissions
   * wherever you see **sitename** in the example commands below, use the website FQDN you made up for this fictitious web server
      * e.g., if the certificate request is for a website named **jimsburgers.com**, then your **sitename.csr** file needs to be named **jimsburgers.com.csr**

```bash
cp ~/my-ed25519-private-key.pem ~/sitename.key && chmod 600 ~/sitename.key
```

1. Create a CSR using that key, your made up website name, and your made up identification information
```bash
openssl req -new -key ~/sitename.key -out ~/sitename.csr
```

1. Sign your CSR using your the same private key that you used to create the request
```bash
openssl x509 -signkey ~/sitename.key -in ~/sitename.csr -req -out ~/sitename-selfsigned.crt
```

1. Review what was put into the certificate
```bash
openssl x509 -in ~/sitename-selfsigned.crt -text -noout
```

1. Verify the certificate's signature against the CAs recognized by your system
```bash
openssl verify ~/sitename-selfsigned.crt
```

Did it verify successfully? If not, why not?

## Use the private CA already set up on the supplied lab VM to sign your CSR, creating a private CA signed certificate
1. Copy your CSR to the incoming requests directory of the private CA
```bash
cd
sudo cp sitename.csr /etc/openvpn/easy-rsa/pki/reqs/
```

1. Sign your CSR using the CA
```bash
sudo bash <<EOF
cd /etc/openvpn/easy-rsa
./easyrsa sign-req server sitename
EOF
```

1. Copy your issued certificate to the standard system directory for certificates and give it proper permissions
```bash
sudo cp /etc/openvpn/easy-rsa/pki/issued/sitename.crt /etc/ssl/certs/
sudo chmod 444 /etc/ssl/certs/sitename.crt
```

1. Examine what is in the private-CA signed certificate and compare it to your self-signed certificate
```bash
openssl x509 -text -noout -in /etc/ssl/certs/sitename.crt
```

1. Verify the certificate's signature against the CAs recognized by your system
```bash
openssl verify /etc/ssl/certs/sitename.crt
```

Copy your CA-signed certificate to another system (not the supplied lab VM) and try to verify the certificate on that system. Will it verify successfully? If not, why not?
