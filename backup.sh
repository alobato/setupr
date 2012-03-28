#!/usr/bin/env bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

# _check_root

###############################################################################

_usage() {
  _print "

Usage:              backup.sh -n 'app_name'

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/backup.sh ) -n 'app_name'

Options:
 
  -h                Show this message
  -n 'app_name'     App name
  "

  exit 0
} 

###############################################################################

pass=

while getopts :hn: opt; do 
  case $opt in
    h)
      _usage
      ;;
    n)
      app_name=$OPTARG
      ;;
    *)
      _error "Invalid option received"

      _usage

      exit 0
      ;;
  esac 
done

if [ -z $app_name ]; then
  _error "-n 'app_name' not given."

  exit 0
fi

###############################################################################

_backup_install() {
	_log "Install Backup Gem"

  if [ ! -n "$1" ]; then
    _log "backup_install() requires the app name as its first argument"
    return 1;
  fi

  _system_install 'libxslt-dev libxml2-dev' # fog (nokogiri) requirements

  gem install backup --no-ri --no-rdoc
  gem install fog --no-ri --no-rdoc
  gem install mail --no-ri --no-rdoc

  if [ -z "rbenv" ]; then
    rbenv rehash
  fi

  # http://stackoverflow.com/a/878647
  crontab -l > tempfile
  echo "00 04 * * * /home/deployer/.rbenv/shims/backup perform --trigger backup -c /home/deployer/apps/$1/current/config/backup.rb" >> tempfile
  crontab tempfile
  rm tempfile

  _log "***** Done!"
}

###############################################################################

_backup_install $app_name
_note_installation "backup"
