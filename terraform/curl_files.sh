#!/bin/bash -x

mkdir /home/ec2-user/sums /home/ec2-user/nginx /home/ec2-user/docker-swarm /home/ec2-user/nginx/configs fly
touch nginx/configs/error.log
echo "1" > /home/ec2-user/nginx/configs/nginx.pid
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/docker-swarm/docker-compose.yml > /home/ec2-user/docker-swarm/docker-compose.yml 
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/sums/airports-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/sums/airports-1.1.0.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/sums/countries-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/Dockerfile > /home/ec2-user/Dockerfile
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/LBDockerfile > /home/ec2-user/LBDockerfile
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/build.sh > /home/ec2-user/build.sh
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/nginx/configs/nginx.conf > /home/ec2-user/nginx/configs/nginx.conf
