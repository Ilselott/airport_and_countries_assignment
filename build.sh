#!/bin/bash
sudo docker build --build-arg SERV=airports --build-arg=VERS=1.0.1 -t ilselott/airports:1.0.1 .
sudo docker build --build-arg SERV=airports --build-arg=VERS=1.1.0 -t ilselott/airports:1.1.0 .
sudo docker build --build-arg SERV=countries --build-arg=VERS=1.0.1 -t ilselott/countries:1.0.1 .
sudo docker build -f LBDockerfile -t ilselott/loadbalancer:1.0.0 .
