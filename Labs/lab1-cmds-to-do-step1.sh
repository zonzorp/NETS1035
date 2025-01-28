#!/bin/bash

#get the setup script
curl https://zonzorp.github.io/NETS1035/Labs/lab1-setup.sh>~/lab1-setup.sh
#make it executable
chmod +x ~/lab1-setup.sh
#run the setup with a student number
sudo ~/lab1-setup.sh <<<"20022725"
#find the encrypted hash file it made
hashfile="$(sudo find / -type f -name encryptedHash 2>/dev/null)"
#get the hash by decrypting the file with the student number
sha256hash=$(ccdecrypt -K "20022725" <"$hashfile")
#find the file which matches the hash, students will have to search from /
aespipefile=$(find $(dirname "$hashfile") -maxdepth 1 -type f -exec sha256sum {} \;|grep $sha256hash|awk '{print $2}')
#decrypt the file with aespipe to get the blowfish-encrypted instructions, then decrypt the blowfish ciphertext to get the actual step 2 instructions
step2instructions=$(aespipe -d -p 4 4<<<'ImSoSmart,ImSoSmart,SMRT!' <"$aespipefile"|openssl bf-cfb -pbkdf2 -d -pass pass:nets1035)
#display the instructions
echo "Step 2:
=======
$step2instructions
"
#remove our lab files
sudo rm $hashfile $aespipefile
