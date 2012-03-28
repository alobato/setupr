#!/bin/bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

_check_root

###############################################################################

_usage() {
  _print "

Usage:              iptables.sh

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/iptables.sh )

Options:
 
  -h                Show this message
  "

  exit 0
} 

###############################################################################

pass=

while getopts :h: opt; do 
  case $opt in
    h)
      _usage
      ;;
    *)
      _error "Invalid option received"

      _usage

      exit 0
      ;;
  esac 
done

###############################################################################

_iptables_install() {
  _log "Install iptables"

  _system_install 'iptables'

  sudo tee /etc/init.d/firewall <<ENDOFFILE
#!/bin/bash
start(){
# Accepting all connections made on the special lo - loopback - 127.0.0.1 - interface
iptables -A INPUT -p tcp -i lo -j ACCEPT
# Rule which allows established tcp connections to stay up
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# SSH:
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# DNS:
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
# HTTP e HTTPS:
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
# Block others ports
iptables -A INPUT -p tcp --syn -j DROP
iptables -A INPUT -p udp --dport 0:1023 -j DROP
}
stop(){
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
}
case "\$1" in
"start") start ;;
"stop") stop ;;
"restart") stop; start ;;
*) echo "start or stop params"
esac
ENDOFFILE

  sudo chmod +x /etc/init.d/firewall
  sudo update-rc.d firewall defaults 99
  sudo /etc/init.d/firewall start

  _log "***** Done!"
}

###############################################################################

_iptables_install
_note_installation "iptables"
