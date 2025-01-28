#!/bin/bash
# check the encrypted file against the password and hash from the student
# password is first cmd line arg, hash is second one
# stdin is encrypted data to check
# if there is anything in $3, it is placed after the -d in aespipe to specify decryption algorithm


data=`aespipe -d $3 -p 4 4<<<"$1"|tr -d '\0'`
sha=`echo "$data"|base64 -id|sha256sum|awk '{print $1}'`
sha2=`echo "$data"|sha256sum|awk '{print $1}'`
echo $sha
echo $sha2
[ "$sha" = "$2" ] && echo "Match" || echo "Sha256sum does not match"
