FROM docker.io/zmkfirmware/zmk-build-arm:stable
RUN apt -y update && apt -y install ssh
WORKDIR /app
