## Dockerfile for gateway
## Version 1.0.0
FROM alpine
LABEL maintainer "."
RUN apk update && apk add ca-certificates
ADD gateway-linux-amd64 .
EXPOSE 9096
ENV HELLO_API_ENDPOINT=ep1 \
    BYE_API_ENDPOINT=ep2
CMD ./gateway-linux-amd64