# TLS/SSL Practice Lab
In this lab, we will observe the handshake that establishes a TLS session. We will see it from the perspective of the server and application tools so that we can see the full decrypted handshake.

## Using openssl to examine TLS Handshake
1. Use the help option for the openssl s_client subcommand to see how you can customize your client connection
```bash
openssl s_client -help
```

1. Try using the client to connect to a web server that does not run TLS, then one that does to see the difference
```bash
openssl s_client -connect georgiancollege.ca:80
openssl s_client -connect georgiancollege.ca:443
```

For this part, we will create a diagnostic service using openssl, then connect to it with openssl's diagnostic client and observe the handshake. One little item to do before we begin is to open up the permissions on the private CA certificate because it is not world-redable and needs to be. This allows us to confirm that our client considers our certificate to be valid.

1. Start a new ssh session with the server in a putty or terminal window
1. Fix the permissions on the private CA certificate file
```
sudo chmod 644 /usr/share/ca-certificates/comp1071/ca.crt
```

1. Start the diagnostic service running using a certificate that already exists on our lab VM and leave that window open with the process running
```bash
sudo openssl s_server -cert /etc/ssl/certs/secure.simpson22725.mytld.crt -key /etc/ssl/private/secure.simpson22725.mytld.key
```

1. Start a second ssh session with the server in a new putty or terminal window
1. Connect to the diagnostic service and watch the handshake in both terminal windows
```bash
openssl s_client -connect localhost:4433
```

1. You can use control-C to terminate the client process, but leave the service process running in the other window

## Packet snoop on TLS Handshake
If you have wireshark running in a GUI, it can show you the TLS handshake graphically which is nice. If you don't have a GUI, you can still see the handshakes using the `ssldump` tool. Let's compare the output of snooping the connection versus being an insider.

1. Start another ssh session running in a third putty or terminal window so we can have a clean space to view our network capture
1. In the third window, install and start running `ssldump` on the loopback interface (we have to use that because of how the VM is set up), then leave it running
```bash
sudo apt install ssldump
sudo ssldump -i lo
```

1. Connect to the diagnostic service from your first ssh session and watch the handshake in all 3 terminal windows to see what the server sees, what the client sees, and what a thrid party would see
```bash
openssl s_client -connect localhost:4433
```

1. You can use control-C to terminate the client process and the service process and the ssldump process

## Grading
This activity exists to build understanding and confirm learning. There are no marks for it, and there is nothing to hand in.
