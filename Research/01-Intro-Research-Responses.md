# Lab 01 Introduction to Cryptography

## Historical Cryptography Techniques
Identify at least 3 different methods of encrypting information throughout the known history of humankind.
   * They should all predate electronic information representation.
   * Try to identify a method from before 1000 B.C., another from the period between 1000 B.C. and 100 A.D., and a third from the period between 100 A.D. and 1900 A.D.
   * What differences are there between them?
   * Would any of them be useful today?

Hieroglyphs and clay tablets with substitution ciphers in Egyptian Tombs and clay tablets used throughout the middle east with a pottery glaze recipe example found from about 1500bc.
Caesar Ciphers used from a few hundred BC up to about the 9th century AD relied mostly on the fact that nearly everyone was illiterate to begin with. Frequency analysis trivially breaks it.
Vigenere cipher created in the 15th century by Bellaso in Italy was polyalphabetic and also introduced use of a keyword. It resisted frequency analysis.
[Pigpen Cipher](https://crypto.interactive-maths.com/pigpen-cipher.html) used by the freeemasons since the 17th century, was a substitution cipher using symbols from a chart to replace letters. Its strength came from the symbols being meaningless unless you knew about the cipher, and had the chart in use. Frequency analysis trivially breaks it.

The ignorance factor no longer exists so pervasively, so the trivial ciphers are useless and were likely regularly broken in their times by those who had an interest in breaking them. Polyalphabetic was more useful and remains a component of more sophisticated techniques in ues today.

## Encoding vs. Encrypting
For each of the following, would you call it encoding or encrypting?
1. Pig Latin - encoding
1. Tweebadoc - encoding
1. Enigma machine - encrypting
1. EBCDIC - encoding
1. JN-25 - encrypting
1. Egyptian Hieroglyphs - both

Can the following programs encrypt/decrypt?
1. vi/vim - yes, uses blowfish with X command
1. nano - no
1. zip - yes
1. tar - can specify use of zip encryption
1. word/excel/powerpoint - yes
1. outlook - yes, but it can be complicated
1. chrome - yes, https comes to mind
1. firefox - yes, https comes to mind

## Simple Ciphers
1. Identify a free tool for Windows that can do Caesar ciphers, including the popular rot13. https://www.softpedia.com/get/Security/Encrypting/Tran-Caesar-Cipher.shtml
1. Identify a free tool for MacOSX that can do Caesar ciphers, including the popular rot13. https://download.cnet.com/Caesar-Cipher/3000-2144_4-24887.html
1. Identify a free tool for Linux that can do Caesar ciphers, including the popular rot13. caesar cli tool
1. Can you find tools for these that work on IOS/Android? https://apps.apple.com/us/app/crypto-cæsar-and-vigenère-ciphers/id1025345594 https://play.google.com/store/apps/details?id=com.monoflop.caesardecryptor&hl=en_CA
1. Try the websites mentioned in the [resources list for this course](../) for simple ciphers. Would they be viable options instead for encrypting/decrypting instead of loading tools on your own machine? - yes

## One-time pad
1. Can you find a real-life example of the use of a one-time pad? - see https://en.wikipedia.org/wiki/One-time_pad

## Encryption in the Movies/TV realm
2. What kind of encryption is important in the following movies?
  * The Numbers Station - one-time pad
  * The DaVinci Code - substitution including reflection ciphers
  * Sneakers - more about breaking encryption using a breakthrough in factoring large primes
  * The Imitation Game - enigma machine
  * A Beautiful Mind - nash solves stego puzzles, not encryption, in this movie

## Challenge
Gurer ner BFF gbbyf gb qb rapbqvat naq qrpbqvat va rirel znwbe BF. Vqragvsl gbbyf sbe lbhe bcrengvat flfgrz gb cresbez gur sbyybjvat gnfxf:

1. Onfr64 rapbqr/qrpbqr - base64
1. Urknqrpvzny naq Bpgny qhzc bs qngn - hexdump
1. Ovanel qhzc bs qngn - xxd
1. mvc naq tmvc pbzcerffvba/qrpbzcerffvba - zip and gzip
