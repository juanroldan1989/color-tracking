#!/bin/bash
set -e

# run database migrations, populate database and seed users
if [ -z  ${RUN_MIGRATIONS} ] || [ ${RUN_MIGRATIONS} -eq 0 ]; then
  bundle exec rake db:migrate db:seed
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
