## Beanstalk

AmazonEC2ContainerRegistryReadOnly to role: aws-elasticbeanstalk-ec2-role

Add inbound ALL TCP to 172.31.0.0/16 on ec2-security-group
Add inbound Postgres to ec2-security-group on database-security-group

### Instances

    sudo docker ps
    sudo docker exec -i -t current_web_1 shell

    # rails console
    sudo docker exec -i -t current_web_1 console

    # shell
    cd /var/app/current && sudo docker-compose exec web launcher bash

Logs are at /var/log/eb-docker/containers/web|sidekiq

## Build Image

        pack build reconnect-api --env NODE_ENV=production --env RAILS_ENV=production --env RAILS_PRODUCTION_KEY=$(cat config/credentials/production.key) --path . --buildpack ./ruby-buildpack  --descriptor project.toml --builder paketobuildpacks/builder:full


## Test Image Locally

        docker run --rm -p 8000:5000 --env DATABASE_URL=postgresql://dcandland@docker.for.mac.host.internal/reconnect_api_development --env RAILS_MASTER_KEY=$(cat config/master.key) --env RAILS_ENV=development --env RAILS_LOG_TO_STDOUT=true --env RAILS_SERVE_STATIC_FILES=true reconnect-api

        docker run --rm --env DATABASE_URL=postgresql://dcandland@docker.for.mac.host.internal/reconnect_api_development --env RAILS_MASTER_KEY=$(cat ../config/master.key) --env RAILS_ENV=development --env RAILS_LOG_TO_STDOUT=true --env RAILS_SERVE_STATIC_FILES=true --entrypoint shell --interactive --tty reconnect-api:latest

## Deploy

1. Push image to ECR

    # Docker Login
    aws ecr get-login-password --profile reconnect-api --region us-west-2 | docker login --username AWS --password-stdin 135203793283.dkr.ecr.us-west-2.amazonaws.com
    docker tag reconnect-api:latest 135203793283.dkr.ecr.us-west-2.amazonaws.com/reconnect-api:latest
    docker push 135203793283.dkr.ecr.us-west-2.amazonaws.com/reconnect-api:latest

1. eb deploy

1. DB migrations ?

Run a service on the EB instance from /var/app/current
    sudo docker-compose run --entrypoint shell web
