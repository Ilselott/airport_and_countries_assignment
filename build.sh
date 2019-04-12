docker build --build-arg SERV=airports --build-arg=VERS=1.0.1 -t airports:1.0.1 .
docker build --build-arg SERV=airports --build-arg=VERS=1.1.0 -t airports:1.1.0 .
docker build --build-arg SERV=countries --build-arg=VERS=1.0.1 -t countries:1.0.1 .
docker build -t loadbalancer:1.0.0 -f loadbalancerDockerfile .
