#!/bin/bash
set -e

# run database migrations, populate database and seed users
bundle exec rake db:migrate db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
