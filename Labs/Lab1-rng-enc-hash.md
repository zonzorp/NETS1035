# Lab 1 RNG, Symmetric Encryption, Hashes

## Grading
The second task contains additional instructions about what you are to submit for this lab.

## Decrypting a message
When doing this task, capture screenshots showing only the commands you used that worked and their results. Your screenshots should include your shell prompts, so I can see what machine you did your work on. Before starting task 2, put your screenshots into a PDF to include when you submit your work for this lab on blackboard.

I recommend that you keep notes and perhaps screenshots of your work on task 2 as well, for future reference but it is not required for this lab.

1. Download and run the lab setup script using sudo - *screenshot!*

```bash
curl https://zonzorp.github.io/NETS1035/Labs/lab1-setup.sh>lab1-setup.sh
sudo bash lab1-setup.sh
```

1. Do not proceed unless you saw the "VM Pwned" message - *screenshot!*
1. Find the file containing the encrypted hash - it is named `encryptedHash` and the linux `find` command can find it for you easily - *screenshot!*
1. Decrypt it using your student number as a password for the ccrypt program - *screenshot!*
1. Find the file on your lab VM that matches the hash digest - *screenshot!*
1. Decrypt that file using aespipe with password `ImSoSmart,ImSoSmart,SMRT!` to get the blowfish encrypted instructions for your next task - *screenshot!*
1. Decrypt your actual instructions for the second task by using openssl to run the blowfish cipher in counter feedback mode with password **nets1035** on the output from your aespipe decryption in the previous step - *screenshot!*

**Note that it it is fine to include more than one command in a screenshot, just make sure it isn't so crowded and tiny that I cannot read it. I will not try to mark anything I cannot read.**
