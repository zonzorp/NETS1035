# Symmetric Encryption
Symmetric encryption is used for many tasks, and is also incorporated into protocols that use multiple encryption techniques.

## Sample tools
openssl is the swiss army knife of OSS encryption. aespipe and ccrypt are examples of simple tools that provide alternate ways to do AES.

### aespipe
aespipe is useful in scripting situations where you wish to use the gpg integration, or want a tool that is just easy to use. This exercise is intended to make you comfortable with running the aespipe comannd alone or in a command pipeline.

1. Install aespipe if necessary.
1. Use aespipe to encrypt the contents of the aespipe man page. Use the file command to see what the system thinks the data is.
1. Use aespipe to encrypt the contents of the aespipe man page. Use the hexdump command to see what the data looks like.
1. Use aespipe to encrypt the contents of the aespipe man page. Use ent to see how information dense it is, and how random the data appears to be. Would aespipe make a reasonable random number generator?
1. Create a tar archive of the /bin directory and pipe it to aespipe before writing the archive. Use the file command to see what is in the archive.
1. Decrypt your archive using aespipe and send the decrypted data to a tar command to list the archive contents without extracting them.
```bash
sudo apt update
sudo apt upgrade
man aespipe | aespipe -p 4 4<<<"1234567890abcdefghij" | file -
man aespipe | aespipe -p 4 4<<<"1234567890abcdefghij" | hexdump | head -20
man aespipe | aespipe -p 4 4<<<"1234567890abcdefghij" | ent
tar cf - /bin | aespipe -p 4 4<<<"1234567890abcdefghij" | file -
tar cf - /bin | aespipe -p 4 4<<<"1234567890abcdefghij" | aespipe -d -p 4 4<<<"1234567890abcdefghij" | tar tvf -
```

### ccrypt
Try the same activities as you did with aespipe, but using ccrypt. Do you find any significant difference in how they work when used for streams of data?

### aescrypt
Try the GUI version of aescrypt for your host operating system. Explore what you can do with it.


