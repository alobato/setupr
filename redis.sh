#!/bin/bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

# _check_root

###############################################################################

_usage() {
  _print "

Usage:              redis.sh

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/redis.sh )

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

_redis_install() {
  _log "Install Redis"

  cd ~
  wget http://redis.googlecode.com/files/redis-2.4.8.tar.gz
  tar xvzf redis-2.4.8.tar.gz
  rm redis-2.4.8.tar.gz
  cd redis-2.4.8
  make
  sudo make install
  sudo cp utils/redis_init_script /etc/init.d/redis_6379
  sudo mkdir /etc/redis
  sudo cp redis.conf /etc/redis/6379.conf
  cd ~
  sudo rm -rf redis-2.4.8
  sudo mkdir /var/redis
  sudo mkdir /var/redis/6379
  sudo sed -e "s|daemonize no|daemonize yes|g" \
    -e "s|pidfile /var/run/redis.pid|pidfile /var/run/redis_6379.pid|g" \
    -e "s|loglevel verbose|loglevel notice|g" \
    -e "s|logfile stdout|logfile /var/log/redis_6379.log|g" \
    -e "s|dir ./|dir /var/redis/6379|g" \
    -i /etc/redis/6379.conf
  sudo update-rc.d redis_6379 defaults
  sudo /etc/init.d/redis_6379 start

  _log "***** Done!"
}

###############################################################################

_redis_install
_note_installation "redis"
