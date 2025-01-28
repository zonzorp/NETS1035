# Lab 1 - RNG, Symmetric Encryption
This lab activity is intended to familiarize you with random number generation and symmetric encryption.

## Using ent
### Entropy Measurement
1. Install the ent tool, or another or your choice that can generate similar output
1. Read the tool man page
1. Entropy
   * How many bits out of every 8 get "used"
   * It measures compression potential
1. What is the chi square test percentage
   * 50% correlates to random data, close to 100 or 0 means not random data
   * up to 1 % off 0 or 100 means non-random data
   * up to 5% off 0 or 100 means suspected non-random data
   * up to 10% off 0 or 100 means might be non-random data
1. Arithmetic mean
   * should be 127.5 for random data
   * this value shows the skew of the data values in the input bytes
1. monte Carlo value for pi
   * only useful with large datasets
   * random data produces result close to pi
   * non-random data is not close to pi, often 4
1. Serial Correlation Coefficient
   * close to 0 for random data, means each byte is unrelated to previous byte
   * close to 1 for predictable data, means each byte is fairly predictable if you have the preceding byte

### Using ent to find shift value for caesar ciphers
man ent | caesar 3 | ent -c | awk '/^[0-9]/{print $2,$3}' | sort -nk 2 | tail

## Random Number Generation
On Windows and on MacOSX, identify a source of random numbers you could use on the command line.
* **Linux system example** - read from the /dev/urandom file (e.g. dd if=/dev/urandom bs=64 count=1|hexdump)
Identify a source for random numbers you could use in the python programming language.

## Symmetric Encryption Tools
There are OSS tools to do encryption and decryption in every major OS. Identify tools for your operating system to perform the following tasks:

1. Caesar cipher encrypt/decrypt
1. 13-character rotation encryption/decryption
1. Is there a free OSS tool for your OS to break these kinds of trivial ciphers?
