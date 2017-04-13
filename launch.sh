#!/bin/sh

RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
export SECRET_KEY_BASE=$(rake secret)

mkdir -p /blog/tmp/pids/
unicorn -E production -c config/unicorn.rb
