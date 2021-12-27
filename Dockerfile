FROM openjdk:8-jdk-alpine

WORKDIR /usr/local/lib

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN curl -u admin:Pgallo123 -o journals.jar "http://100.121.114.58:8081/repository/maven-snapshots/com/semperti/trial/journals/1.1-SNAPSHOT/journals-1.1-20211222.205330-1.jar" -L

EXPOSE 8080

ENTRYPOINT ["java","-jar","/usr/local/lib/journals.jar"]


