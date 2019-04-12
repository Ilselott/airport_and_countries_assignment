FROM openjdk

ARG VERS
ARG SERV

WORKDIR /home
COPY ./sums/$SERV-$VERS.txt ./$VERS.txt
RUN curl -SL https://s3-eu-west-1.amazonaws.com/devops-assesment/$SERV-assembly-$VERS.jar -o $SERV-assembly-$VERS.jar && sha1sum /home/$VERS.txt && mv /home/$SERV-assembly-$VERS.jar /home/app.jar
ENTRYPOINT java -jar /home/app.jar
