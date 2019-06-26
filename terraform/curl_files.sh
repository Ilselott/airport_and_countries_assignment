#!/bin/bash -x

sudo mkdir /home/ec2-user/fly/
sudo mkdir /home/ec2-user/fly/sums /home/ec2-user/fly/nginx /home/ec2-user/fly/docker-swarm /home/ec2-user/fly/nginx/configs
touch nginx/configs/error.log
echo "1" > /home/ec2-user/fly/nginx/configs/nginx.pid
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/docker-swarm/docker-compose.yml > /home/ec2-user/fly/docker-swarm/docker-compose.yml 
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/fly/sums/airports-1.0.1.txt
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/fly/sums/airports-1.1.0.txt
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/fly/sums/countries-1.0.1.txt
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/Dockerfile > /home/ec2-user/fly/Dockerfile
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/LBDockerfile > /home/ec2-user/fly/LBDockerfile
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/build.sh > /home/ec2-user/fly/build.sh
curl https://raw.githubuser/flycontent.com/Ilselott/airport_and_countries_assignment/master/nginx/configs/nginx.conf > /home/ec2-user/fly/nginx/configs/nginx.conf
