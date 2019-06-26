#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod 755 /usr/local/bin/docker-compose
sudo service docker start

sudo curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/terraform/curl_files.sh > /home/ec2-user/curl_files.sh
sudo chmod 755 /home/ec2-user/curl_files.sh
sudo ./home/ec2-user/curl_files.sh
sudo cd /home/ec2-user/fly
sudo docker swarm init
docker-compose up
