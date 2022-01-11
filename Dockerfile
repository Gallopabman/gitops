FROM openjdk:8-jdk-alpine

ARG VERSION

WORKDIR /usr/local/lib

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY /workspace/bc-pgalleguillo/journals-ci/Code/target/journals-$VERSION-SNAPSHOT.jar ./

EXPOSE 8083

ENTRYPOINT ["java","-jar","./journals-$VERSION-SNAPSHOT.jar"]
