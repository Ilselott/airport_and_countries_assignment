#!/bin/bash -x

sudo mkdir /home/ec2-user/fly/
sudo mkdir /home/ec2-user/fly/sums
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/airports-1.0.1.txt > /home/ec2-user/fly/sums/airports-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/sums/countries-1.0.1.txt > /home/ec2-user/fly/sums/countries-1.0.1.txt
curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/Dockerfile > /home/ec2-user/fly/Dockerfile
