# NETS1035 Lab 3 - SSH Tunnels
In this lab, you will create a proxy tunnel, and a reverse proxy tunnel.

## Proxy Tunnel
We have 2 VMs to use for this activity. We have the main lab VM which has many services running on it and multiple interfaces and IP addresses. We also have our backup server VM with rsync and VPN client services running. For this part of the lab, we will create a proxy for access to the POP3 server running on a private IP address on our main server, which we will connect to using our backup server which otherwise cannot reach the POP3 service on that server address.

### On the main lab VM 
1. Open the port we want to use for forwarding in the ufw firewall
```bash
sudo ufw allow 8088/tcp
```

1. Start an ssh proxy running, listening to the vm's ens33 address port 8088, forwarding that port to the POP3 service running on address 172.16.4.2, port 110, using the `dennis` account for which the password is also `dennis` - _**screenshot**_

```bash
# Find our IP address to use for the external user to connect
ip a s ens33
# Start a forwarding proxy on that port in the background
ssh -L our-lab-vm-ip:8088:172.16.4.2:110 -N dennis@localhost
```

### On the backup server
1. Try to ping the protected IP address, it shouldn't be able to reach it
```bash
ping -c 3 172.16.4.2
```

1. Use nmap to see the proxy listening on port 8088 of the ssh server
```bash
sudo apt install nmap
nmap our-lab-vm-ip
```

1. Connect to the POP3 service running on the protected 172.16.4.2 host using our proxy on the lab main vm, you should get a greeting from the dovecot service running on that address - do not stop this connection or window yet! - _**screenshot**_
```bash
telnet our-lab-vm-ip 8088
```

### On the main lab VM in a new window
1. View the connections that we have established with our proxy using netstat - _**screenshot**_
   * you should see the remote connection to port lab-vm-ip:8088, which should show as the program ssh that made the proxy
   * the connection from labVM:sshd to 172.16.4.2:110, which is the forwarded ssh proxy connection
   * the connection from labVM:port 110 which is the dovecot pop3 service back to the labVM sshd
```bash
sudo netstat -tpn |egrep '8088|110|State'
```

So you should be seeing that the backup server which had no access to 172.16.4.2 at all can now access it using an ssh-protected channel.

## Reverse Proxy Tunnel
We have 2 VMs to use for this activity. We have the main lab VM which has many services running on it and multiple interfaces and IP addresses. We also have our backup server VM with rsync and VPN client services running. For this part of the lab, we will create a proxy for access to the POP3 server running on a private IP address on our main server, which we will connect to using our backup server which otherwise cannot reach the POP3 service on that server address.

### On the main lab VM
1. Block access to the IMAP service from the network - _**screenshot**_
```bash
sudo ufw status numbered
sudo ufw delete ## where ## is the rule number for the 143/tcp rule
```

1. Create a reverse proxy on the backup server by running the ssh command on the main lab vm
```bash
ssh -R *:8143:localhost:143 -N student@backup-srvr-ip
```

Now we should be able to connect to port 8143 on the backup srvr and get responses from the IMAP service on the main VM, even though its firewall is trying to stop us from getting there.

### On the backup server
1. Try to connect to the imap service on the main lab vm
```bash
telnet our-lab-vm-ip 143
```

1. Use nmap to see if it is listening on port 143
```bash
sudo apt install nmap
nmap our-lab-vm-ip
```

1. Connect to the IMAP service running on the main lab VM by connecting to our own localhost proxy port, you should get a greeting from the imap service running on the main VM - do not stop this connection or window yet! - _**screenshot**_
```bash
telnet localhost 8143
```

### On the main lab VM in a new window
1. View the connection that we have established with our proxy using netstat - _**screenshot**_
   * the connection from localhost program ssh to localhost:143, which is the ssh command we ran to create the reverse proxy
   * the connection from localhost's dovecot imap service to the localhost ssh program
   * note that there is no way to see on here where that connection is really coming from
```bash
sudo netstat -tpn |egrep '143|State'
```

### On the backup server in a new window
1. View the connection that we have established with our proxy using netstat - _**screenshot**_
   * the connection from localhost program telnet to localhost:8143, which is being provided by the ssh daemon because we ran a reverse proxy on it from the remote machine
   * the connection from localhost:8143 to the localhost telnet program
   * note that there is no way to see on here where that connection is really coming from or going to
```bash
sudo netstat -tpn |egrep '8143|State'
```

1. View the ssh connections with `who` and `netstat` - _**screenshot**_
```bash
who
sudo netstat -tpn |egrep '22|State'
```

1. You should be seeing one more sshd connection in the `netstat` listing than the number of user ssh sessions that users have started as shown by the `who` command. For each of those sshd processes, use ps to see what processes have been spawned by that sshd. - _**screenshot**_
```bash
ps -ef|egrep '#|##|###|PID' where #, ##, ### are a process numbers for sshd from the netstat output
```

1. The output should look something like this:
```bash
dennis@backup-srv:~$ ps -ef|egrep '269173|125104|277773|PID'|grep -v grep
UID          PID    PPID  C STIME TTY          TIME CMD
root      125104     955  0 Nov25 ?        00:00:00 sshd: dennis [priv]
dennis    125273  125104  0 Nov25 ?        00:00:00 sshd: dennis@pts/0
root      269173     955  0 02:57 ?        00:00:00 sshd: dennis [priv]
dennis    269288  269173  0 02:57 ?        00:00:00 sshd: dennis
root      277773     955  0 03:23 ?        00:00:00 sshd: dennis [priv]
dennis    277908  277773  0 03:23 ?        00:00:00 sshd: dennis@pts/1
```

The sshd processes whose PIDs are the ones we looked for are the forked monitor processes for sshd. The sshd processes that have a virtual terminal *pts/0* and *pts/1* are probably legitimate login sessions because they have terminals attached. Process 269288 in the example, which is a child of 269173 (one of the ones that netstat showed us) does not have a terminal, and is the one for the tunnel. So if look back at the netstat listing for that sshd process, the foreign address for that connection is the place our tunneler connected to. But since the proxy is actually making a second forwarded connection at the remote end, we cannnot know what it is connected to, or even where.

So you can see that the backup server which had no access to the protected service on the main lab VM can now access it using an ssh-protected channel.

## Grading
Submit a single PDF containing the screenshots marked in the instructions. Only one PDF is to be submitted and other formats will not be accepted.
