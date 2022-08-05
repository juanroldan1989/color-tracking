# ECS Terminology

## ECS Task Definition

A "task definition" is simply a list of containers that should run together. It's kind of like a Procfile, or a docker-compose configuration.

So, if your application has one container running Nginx, one running Unicorn, and one running Sidekiq then all three might be contained within your "task definition."

## ECS Service Definition

The "service" configuration lets you specify how many "tasks" (a.k.a. copies of your app) should run, and how they're load balanced.

E.g.: I want three copies of my app to run, with load balancing on port 80.

## TODO

TODO: Remove ECS keys from repository. Add steps indicating how to generate and include them in the repo for deployment.
