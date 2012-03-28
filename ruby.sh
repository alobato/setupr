#!/bin/bash

wget -N --quiet https://raw.github.com/alobato/setupr/master/lib.sh; . ./lib.sh

# _check_root

###############################################################################

_usage() {
  _print "

Usage:              ruby.sh

Remote Usage:       bash <( curl -s https://raw.github.com/alobato/setupr/master/ruby.sh )

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
  _log "Install Ruby"

  _system_install 'build-essential zlib1g-dev libssl-dev libreadline5-dev libyaml-dev'
  cd ~
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

  mkdir ~/tmp && cd ~/tmp
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz
  tar -xzvf ruby-1.9.3-p125.tar.gz
  cd ruby-1.9.3-p125
  ./configure --prefix=$HOME/.rbenv/versions/1.9.3-p125
  make
  make install
  cd ~
  rm -rf ~/tmp

  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
  eval "$(rbenv init -)"
  export RAILS_ENV=production
  export RACK_ENV=production

  rbenv global 1.9.3-p125
  sleep 2
  gem update --system
  gem install bundler --no-ri --no-rdoc
  rbenv rehash

  _log "***** Done!"
}

###############################################################################

_redis_install
_note_installation "ruby"
