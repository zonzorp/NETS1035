# RNG Links
Resources used or mentioned in this lesson:

* [Wikipedia page on RNG with an excellent table of algorithms and where they are used](https://en.wikipedia.org/wiki/List_of_random_number_generators)
* [/dev/random /dev/urandom reference info](https://en.wikipedia.org/wiki//dev/random)
* [ent entropy/random number quality assessor](http://www.fourmilab.ch/random/)
* [the much briefer but still excellent Arch Linux wiki page on random number sources](https://wiki.archlinux.org/index.php/Random_number_generation)
* [rng-tools reference info](https://wiki.archlinux.org/index.php/Rng-tools)
* [haveged entropy booster](https://wiki.archlinux.org/index.php/Haveged)
* [dieharder rng test suite](https://webhome.phy.duke.edu/~rgb/General/dieharder.php)
* [FIPS140-2 NIST/CSE Security Standard](https://en.wikipedia.org/wiki/FIPS_140-2)
* [Random number source for python](https://docs.python.org/3/library/random.html)
* [How do you know if an RNG is working](https://blog.cryptographyengineering.com/2014/03/19/how-do-you-know-if-rng-is-working/)

* [Rolling your own RNG](https://xkcd.com/221/)
* [Ultimate swiss army knife](https://www.thisiswhyimbroke.com/the-ultimate-swiss-army-knife/)

## Sample commands from the slides

### CLI RNG invocation
```bash
echo $RANDOM
rand
dd if=/dev/urandom bs=1M count=1 of=/dev/null
openssl rand 1048576|dd of=/dev/null
hpenc -r -b 10M -c 100 |dd bs=10M of=/dev/null
```

### ent examples
```bash
man ent

man ent | ent

man ent | ent -c

man ent | caesar 3 

man ent |
 caesar 3 |
 ent -c |
 awk '/^[0-9]/{print $2,$3}' |
 sort -nk 2 |
 tail 5

dd if=/dev/urandom bs=1M count=1 | ent
```

### rngtest
```bash
dd if=/dev/urandom bs=1M count=1 | rngtest

```

### openssl for rng
```bash
openssl speed rand
openssl rand 1048576 | dd of=/dev/null
openssl rand 1048576 | ent
openssl rand 1048576 | rngtest
openssl rand 1048576 | dieharder -a
```
