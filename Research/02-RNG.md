# Research: RNG, Using ent
This lab activity is intended to familiarize you with random number generation and symmetric encryption.

## Using ent
### Entropy Measurement
1. Install the ent tool, or another or your choice that can generate similar output
1. Read the tool man page
1. Use the ent tool to measure the data from several sources
   * the man page for the tool
   * your kernel file in /boot/vmlinuz-whatever
   * your /etc/hosts file
   * the man page for ent encoded using base64
   * the ova file used for the NETS1028 virtual machine
1. What are your thoughts on whether you could use this tool to make guesses about the content of data from an unknown source?
1. What kinds of conclusions might you be able to draw about data from it?

### Using ent to find shift value for caesar ciphers
Find the shift values for each of the following caesar-cipher encrypted files using ent if you can.
* [File 1](02-file1.enc)
* [File 2](02-file2.enc)
* [File 3](02-file3.enc)

Test your deduced shift values to see if they worked right. Is frequency distribution a reliable way to find caesar cipher shift values?

## Random Number Generation
On Windows or on MacOSX, identify a source of random numbers you could use on the command line and verify it works. Try using ent to compare the quality of random numbers produced by different sources in one of those operating systems.
### Linux system example
* read from the /dev/urandom file (e.g. dd if=/dev/urandom bs=64 count=1|ent)

Identify a source for random numbers you could use in the python programming language.

### Optional: Compare PRNGs
#### Speed/Volume
* **/dev/random** is a random number source that blocks when insufficient entropy is available. So while it produces very high quality random numbers, it does so too slowly for any real use unless you have custom random number generation hardware.
* **/dev/urandom** does not block and produces the best random numbers it can as fast as it can. Both are kernel based, so are expected to be trustworthy and fast. Measure the speed of getting numbers from each of them.
```bash
time dd if=/dev/random bs=8 count=2 of=/dev/null
time dd if=/dev/urandom bs=10M count=100 of=/dev/null
```

* **openssl** is a useful tool for many crypto activities. It can generate random numbers.
```bash
time openssl rand 1048576000|dd of=/dev/null
```

* **hpenc** is a high performance tool for encryption/decryption, and a high performance random number generator. It gets its advantage mostly from being multi-threaded so it parallelizes well.
   * hpenc is not distributed in a package. You can download and build the [**hpenc**](https://github.com/vstakhov/hpenc) program. If you are doing this on Ubuntu, you will also need to install the **cmake**, **libsodium-dev**, and **libssl-dev** packages.
```bash
cd
sudo apt update
sudo apt install cmake libsodium-dev libssl-dev
wget https://github.com/vstakhov/hpenc/archive/master.zip && unzip master.zip && rm master.zip
cmake .
make
sudo make install
```

```bash
time hpenc -r -b 10M -c 100 |dd bs=10M of=/dev/null
```

#### Quality
For each of the tools, run the tool 3 times in a row to obtain a block of random data in a size you might use for key generation, 2K bytes. Each time, use ent to measure the produced data.
1. For each tool, does it consistently make good random numbers? poor random numbers? random numbers of unpredictable quality?
1. What happens to the results with 4K blocks? 256 bit blocks?

```bash
dd if=/dev/urandom bs=2k count=1|ent
dd if=/dev/urandom bs=2k count=1|ent
dd if=/dev/urandom bs=2k count=1|ent

openssl rand 2048|ent
openssl rand 2048|ent
openssl rand 2048|ent

hpenc -r -b 2K -c 1 |ent
hpenc -r -b 2K -c 1 |ent
hpenc -r -b 2K -c 1 |ent
```

## Grading
There is nothing to submit for this research activity. It is a learning reinforcement tool.
