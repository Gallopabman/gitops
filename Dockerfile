FROM openjdk:8-jdk-alpine

ARG VERSION

WORKDIR /usr/local/lib

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY ./Code/target/journals-$VERSION.jar ./journals.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","./journals.jar"]
