FROM openjdk:8-jre-alpine

RUN apk update upgrade \
    && apk add --no-cache unzip

ARG VERSION
ENV VERSION $VERSION

COPY apollo-adminservice-${VERSION}-github.zip /apollo-adminservice/apollo-adminservice-${VERSION}-github.zip

RUN unzip /apollo-adminservice/apollo-adminservice-${VERSION}-github.zip -d /apollo-adminservice \
    && rm -rf /apollo-adminservice/apollo-adminservice-${VERSION}-github.zip \
    && chmod +x /apollo-adminservice/scripts/startup.sh

FROM openjdk:8-jre-alpine

ENV APOLLO_RUN_MODE "Docker"
ENV SERVER_PORT 8090

RUN apk update upgrade \
    && apk add --no-cache procps curl bash

COPY --from=0 /apollo-adminservice /apollo-adminservice

EXPOSE $SERVER_PORT

CMD ["/apollo-adminservice/scripts/startup.sh"]