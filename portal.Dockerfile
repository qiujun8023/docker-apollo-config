FROM openjdk:8-jre-alpine

RUN apk update upgrade \
    && apk add --no-cache unzip

ARG VERSION
ENV VERSION $VERSION

COPY apollo-portal-${VERSION}-github.zip /apollo-portal/apollo-portal-${VERSION}-github.zip

RUN unzip /apollo-portal/apollo-portal-${VERSION}-github.zip -d /apollo-portal \
    && rm -rf /apollo-portal/apollo-portal-${VERSION}-github.zip \
    && chmod +x /apollo-portal/scripts/startup.sh

FROM openjdk:8-jre-alpine

ENV APOLLO_RUN_MODE "Docker"
ENV SERVER_PORT 8070

RUN apk update upgrade \
    && apk add --no-cache procps curl bash

COPY --from=0 /apollo-portal /apollo-portal

EXPOSE $SERVER_PORT

CMD ["/apollo-portal/scripts/startup.sh"]