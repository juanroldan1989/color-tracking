# Dockerfile MUST be placed at the `root` directory level of Rails app
# otherwise we get error:

# `ADD failed: Forbidden path outside the build context`

# Symlinks that point outside the build context could also generate this error.
# It's only possible to ADD/COPY paths within the build context.

FROM ruby:3.0.0

LABEL maintainer="Juan Roldán <juanroldan1989@gmail.com>"

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ADD . /myapp
WORKDIR /myapp

RUN bundle install

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD [ "puma", "-C", "config/puma.rb" ]
