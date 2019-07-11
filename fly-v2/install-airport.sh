#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo service docker start

sudo curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/fly-v2/curl_files.sh > /home/ec2-user/curl_files.sh
sudo chmod 755 /home/ec2-user/curl_files.sh
sudo ./home/ec2-user/curl_files.sh
sudo docker build --build-arg SERV=airports --build-arg=VERS=1.0.1 -t airports:1.0.1 /home/ec2-user/fly
sudo docker run -p 8080:8080 airports:1.0.1
