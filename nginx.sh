#!/bin/bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

# _check_root

###############################################################################

_usage() {
  _print "

Usage:              nginx.sh

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/nginx.sh )

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

_nginx_install() {
  _log "Install Nginx"

  sudo add-apt-repository ppa:nginx/stable
  sudo apt-get -y update
  _system_install 'nginx'
  sleep 3
  sudo service nginx start

  _log "***** Done!"
}

###############################################################################

_nginx_install
_note_installation "nginx"
