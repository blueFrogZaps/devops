ARG VERSION=20.04

FROM ubuntu:${VERSION}

RUN apt-get update -y

CMD ["bash"]
