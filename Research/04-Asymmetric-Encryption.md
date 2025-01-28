# Asymmetric Encryption
This activity is intended to introduce asymmetric encryption tools.

## SSH keys on the command line
1. Generate SSH keys on your host OS
```bash
ssh-keygen
```
1. Copy the public key to the student account on the Linux VM, do not use Microsoft's instructions where they tell you to use scp! If you are on Windows, you might find [this link](https://www.chrisjhart.com/Windows-10-ssh-copy-id/) helpful.
```bash
ssh-copy-id student@ipaddress
```
1. Verify you can login to the Linux VM student account using ssh without having to give a password
```bash
ssh student@ipaddress
```

## Using ssh-agent
ssh-agent is a daemon you can run to supply your ssh keys when needed. If you add your keys to the daemon, it will ask for each key file decryption passphrase when it adds those keys, and then you will no longer need to give the passphrase to use those keys until the daemon ends. The daemon is run per user so that no user has access to any other user's ssh-agent daemon. To try it, you can use the following commands to start the daemon if you do not already have it running, add your keys if they aren't already there, and give you a status report on the daemon. You can add these lines to the end of your ~/.bashrc file if you want to always have your ssh keys available through the daemon whenever you log into the system.
```bash
pgrep -u $USER ssh-agent 2>&1 >/dev/null || ssh-agent -s >~/.ssh/agent-vars.sh
[ -f ~/.ssh/agent-var.sh ] && source ~/.ssh/agent-vars.sh
pgrep -u $USER ssh-agent 2>&1 >/dev/null && ssh-add -l || ssh-add
```

## SSH keys with putty (only if you are using Windows)
1. Install your SSH private key into putty
1. Verify you can use it to log into your VM without requiring a password

## RSA, DSA, ECDH, ECDSA, Ed25519, Ed448 keypairs and parameters
When keys are generated, an algorithm is chosen based on the purpose of the key. When the key is used for encryption and decryption, we call the output a private key. When the key is intended for use in signing or key exchange, we call that the output a set of parameters. For encryption, we typically use RSA, but may use EC with one of several specified curves. For key exchange, we use DH or ECDH. For signing, we use DSA, ECDSA, Ed25519, or Ed448.

1. Generate keys and parameters for each of the RSA, DSA, ECDSA, Ed25519, and Ed448 algorithms

```bash
# 2K bit RSA key generation
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -out my-rsa-private-key.pem

# 2K bit DH parameters and key exchange parameters generation
openssl dhparam 2048 >dhparamsfile.pem
openssl genpkey -paramfile dhparamsfile.pem -out my-dh-private-key.pem
rm dhparamsfile.pem

# 2K bit DSA signing key generation
openssl dsaparam 2048 >dsaparamsfile.pem
openssl genpkey -out my-dsa-private-key.pem -paramfile dsaparamsfile.pem
rm dsaparamsfile.pem

# 256 bit ECDSA signing key generation
openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:secp384r1 -out my-ecdsa-private-key.pem

# Ed25519 signing key generation
openssl genpkey -algorithm ed25519 -out my-ed25519-private-key.pem

# Ed448 signing key generation
openssl genpkey -algorithm ed448 -out my-ed448-private-key.pem
```

1. View the resulting keys/parameters using openssl to see the difference in what was generated for each algorithm chosen

```bash
openssl pkey -in my-rsa-private-key.pem -text -noout
openssl pkey -in my-dh-private-key.pem -text -noout
openssl pkey -in my-dsa-private-key.pem -text -noout
openssl pkey -in my-ecdsa-private-key.pem -text -noout
openssl pkey -in my-ed25519-private-key.pem -text -noout
openssl pkey -in my-ed448-private-key.pem -text -noout
```

## OpenPGP keypair

1. Before we use gpg with Ubuntu 20.04 on our VM, we have to fix something which is broken by default on it. Create a file in your personal gnupg configuration directory and tell it to use the standard dns resolver for names, then restart the dirmngr process to make it re-read the configuration file. If you have to redo this part of the lab, you do not need to redo this fix.

```bash
echo standard-resolver > ~/.gnupg/dirmngr.conf
pkill -u `id -un` dirmngr
```

1. Generate a keypair for OpenPGP using the gpg command or tool and create an exported public key file

```bash
gpg --gen-key
gpg --armor --export keyname
```

1. Publish it to the ubuntu public key server

```bash
gpg --keyserver keyserver.ubuntu.com --send-keys keyfingerprintstring
```

1. Verify a classmate can retrieve your public key from the keyserver

```bash
gpg --keyserver keyserver.ubuntu.com --search-keys "name for key"
```

1. Obtain a classmate's key without using a keyserver - have them export it, and then you import it
1. What is the oldest key you can find for me, Dennis Simpson on the ubuntu keyserver?

## GPG message encryption
1. Encrypt a message for your classmate using your gpg key to sign it, and their public key to encrypt it

```bash
somethingtocreateamessage | gpg --encrypt --sign --armor --recipient recipientid >gpg-encrypted-message-for-recipientid
```

1. Decrypt the message someone made for you in step 1

```bash
cat encryptedmessagefile|gpg --decrypt
```
