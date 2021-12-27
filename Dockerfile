FROM openjdk:8-jdk-alpine

WORKDIR /usr/local/lib

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN curl -u admin:Pgallo123 -o journals.jar "http://100.121.114.58:8081/repository/maven-snapshots/com/semperti/trial/journals/2.2-SNAPSHOT/journals-2.2-20211227.124509-2.jar" -L

EXPOSE 8080

ENTRYPOINT ["java","-jar","/usr/local/lib/journals.jar"]


