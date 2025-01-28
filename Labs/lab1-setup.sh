#!/bin/bash

### Decrypting a message
#1. Download and run the lab setup script using sudo
#
#```bash
#curl https://zonzorp.github.io/NETS1035/Labs/lab1-setup.sh|bash
#```
#
#1. Do not proceed unless you saw the "VM Pwned" message
#1. Find the file named `encryptedHash` (he linux `find` command can find it for you easily)
#1. Decrypt it using your student number as a password for the ccrypt program
#1. Get the SHA256 hash digest from the decrypted file
#1. Find the file on your lab VM that has the same hash digest
#1. Decrypt that file using aespipe with password `ImSoSmart,ImSoSmart,SMRT!` to get the blowfish encrypted instructions for your next task
#1. Decrypt those instructions using openssl with cipher bf-cfb and pbkdf2 key stream generation to get your instructions for step 2 of the lab
#
#

verbose="no"
while [ $# -gt 0 ]; do
	case "$1" in
		-v) verbose="yes" ;;
		-n) nosnumcheck="yes" ;;
		*) echo "bad command line"; exit 2 ;;
	esac
	shift
done
# check for programs we need
[ ! -e /usr/bin/ccrypt ] && echo "ccrypt needs to be installed before doing this lab" && exit 2
[ ! -e /usr/bin/aespipe ] && echo "aespipe needs to be installed before doing this lab" && exit 2
[ ! -e /usr/bin/openssl ] && echo "openssl needs to be installed before doing this lab" && exit 2
[ ! -e /usr/bin/sha256sum ] && echo "sha256sum needs to be installed before doing this lab" && exit 2
[ ! -e /usr/bin/curl ] && echo "curl needs to be installed before doing this lab" && exit 2
[ "`id -u`" != "0" ] && echo "Need to run as root, use sudo" && exit 2

# check for student's own VM
read -p "Your student Number? " snum
[ "$nosnumcheck" != "yes" ] && if [ "$(hostname|sed s/pc//)" != "$snum" ]; then
	echo "Your hostname should be pc$snum - fix it before doing this lab"
	exit 1
fi
[ "$verbose" = "yes" ] && echo Student number $snum

#find and remove old encrypted files if being re-rerun
[ "$verbose" = "yes" ] && echo Removing old files belonging to $snum
for hashfile in $(find / -type f -name encryptedHash 2>/dev/null); do
  aespipefile=$(find $(dirname "$hashfile") -maxdepth 1 -type f -exec sha256sum {} \; 2>/dev/null|grep $(cat "$hashfile"|ccdecrypt -K "$snum")|awk '{print $2}') &&
  sudo rm $hashfile $aespipefile
done


# places we might drop files into
dir="/usr /home /lib /var"
[ "$verbose" = "yes" ] && echo Candidate destinations include $path

# get a single random directory name from the tree(s) listed in $path and put that in $path
function getone {
	path=${1:-$dir}
	m=$((RANDOM%6+1))
	for ((i=1;i<$m;i++)); do
		[ "$verbose" = "yes" ] && echo "loop $i"
		if [ $(find $path -maxdepth 1 -type d|wc -l) -gt 4 ]; then
			[ "$verbose" = "yes" ] && echo getting subdir for $path
			path=$(find $path -maxdepth 1 -type d |sed -n $((RANDOM % $(find $path -maxdepth 1 -type d|wc -l) + 1))p)
		fi
	done
}

getone
[ "$verbose" = "yes" ] && echo target dir for files is $path

curl https://zonzorp.github.io/NETS1035/Labs/step2-lab1.enc |
    aespipe -p 4 4<<<'ImSoSmart,ImSoSmart,SMRT!' |
    tee $path/$(sha256sum<<<"$(date '+%Y%m%d%H%M%S')"|cut -c 1-16) |
    sha256sum |
    awk '{print $1}'|
    ccencrypt -K "$snum" > $path/encryptedHash
[ "$verbose" = "yes" ] && echo files put into $path

echo "VM Pwned!"
[ -f lab1-setup.sh ] && rm lab1-setup.sh
