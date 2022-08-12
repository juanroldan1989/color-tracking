# ECS Terminology

## Task Definition

A "task definition" is simply a list of containers that should run together. It's kind of like a Procfile, or a docker-compose configuration.

So, if your application has one container running Nginx, one running Unicorn, and one running Sidekiq then all three might be contained within your "task definition."

## Service Definition

The "service" configuration lets you specify how many "tasks" (a.k.a. copies of your app) should run, and how they're load balanced.

E.g.: I want three copies of my app to run, with load balancing on port 80.

## Deployment

1. Official steps for ECS CLI Configuration:
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html

2. Place both `ecs-cli.asc` and `public_key_ecs.txt` files inside `backend/infrastructure/aws-ecs` folder.

3. Login into AWS Console -> EC2 -> Key pairs -> Create key pair

4. Download `private-ecs-key.cer` and place it inside `backend/infrastructure/aws-ecs` folder

5. Deployment instructions:

```ruby
backend/infrastructure/aws-ecs/setup-aws-ecs.sh
```

This script takes care of:

- Cluster configuration and creation
```ruby
$ ecs-cli configure --region us-east-1 --cluster color-tracking --config-name color-tracking
```

- ECS Key Pair configuration, EC2 Instance Types and Cluster capability
```ruby
$ ecs-cli up --keypair ecs --capability-iam --size 2 --instance-type t3.medium --cluster-config color-tracking --force
```

- ECS Deployment of tasks with containers
```ruby
$ ecs-cli compose up --cluster color-tracking --create-log-groups
```

- Check containers status
```ruby
$ ecs-cli ps --cluster color-tracking
```

6. Cluster deletion and resources cleanup
```ruby
$ ecs-cli down --cluster color-tracking --force
```
