#!/bin/bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

_check_root

###############################################################################

_usage() {
  _print "

Usage:              mysql.sh -p 'password'

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/mysql.sh ) -p 'test'

Options:
 
  -h                Show this message
  -p 'password'     MySQL password
  "

  exit 0
} 

###############################################################################

pass=

while getopts :hp: opt; do 
  case $opt in
    h)
      _usage
      ;;
    p)
      pass=$OPTARG
      ;;
    *)
      _error "Invalid option received"

      _usage

      exit 0
      ;;
  esac 
done

if [ -z $pass ]; then
  _error "-p 'pass' not given."

  exit 0
fi

###############################################################################

_mysql_install() {
	_log "Install MySQL"

  if [ ! -n "$1" ]; then
    _log "mysql_install() requires the root pass as its first argument"
    return 1;
  fi

  echo "mysql-server-5.1 mysql-server/root_password password $1" | debconf-set-selections
  echo "mysql-server-5.1 mysql-server/root_password_again password $1" | debconf-set-selections

  _system_install 'mysql-server mysql-client libmysqlclient-dev'

  _log "***** Done!"
}

###############################################################################

_mysql_install $pass
_note_installation "mysql"
