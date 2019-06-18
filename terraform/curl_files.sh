#!/bin/bash -x

mkdir sums nginx docker-swarm nginx/configs
touch nginx/configs/error.log
echo "1" > nginx/configs/nginx.pid
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/docker-swarm/docker-compose.yml > docker-swarm/docker-compose.yml 
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > sums/airports-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > sums/airports-1.1.0.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > sums/countries-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/Dockerfile > Dockerfile
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/LBDockerfile > LBDockerfile
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/build.sh > build.sh
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/terraform/setup_docker.sh > setup_docker.sh
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/nginx/configs/nginx.conf > nginx/configs/nginx.conf
