#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

export TMPDIR=/var/tmp
export TMP=/var/tmp
export TEMP=/var/tmp

rails db:migrate
bundle exec sidekiq -C config/sidekiq.yml
