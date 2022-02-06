FROM openjdk:8-jre-alpine

RUN apk update upgrade \
    && apk add --no-cache unzip

ARG VERSION
ENV VERSION $VERSION

RUN ls -lh

COPY apollo-configservice-${VERSION}-github.zip /apollo-configservice/apollo-configservice-${VERSION}-github.zip

RUN unzip /apollo-configservice/apollo-configservice-${VERSION}-github.zip -d /apollo-configservice \
    && rm -rf /apollo-configservice/apollo-configservice-${VERSION}-github.zip \
    && chmod +x /apollo-configservice/scripts/startup.sh

FROM openjdk:8-jre-alpine

ENV APOLLO_RUN_MODE "Docker"
ENV SERVER_PORT 8080

RUN apk update upgrade \
    && apk add --no-cache procps curl bash

COPY --from=0 /apollo-configservice /apollo-configservice

EXPOSE $SERVER_PORT

CMD ["/apollo-configservice/scripts/startup.sh"]