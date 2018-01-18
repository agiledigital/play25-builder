#
# Play 2.5 Build Image
# Docker image with libraries and tools as required for building Play 2.5 projects using SBT 
#

FROM frolvlad/alpine-oraclejdk8
MAINTAINER Agile Digital <info@agiledigital.com.au>
LABEL Description="Docker image with libraries and tools as required for building Play 2.5 projects using SBT " Vendor="Agile Digital" Version="0.1"

RUN apk add --update --no-cache bash libsodium curl

ENV sbt_version 0.13.16
ENV sbt_home /usr/local/sbt
ENV PATH ${PATH}:${sbt_home}/bin
ENV HOME /home/jenkins

RUN addgroup -S -g 10000 jenkins
RUN adduser -S -u 10000 -h $HOME -G jenkins jenkins

# Install sbt
RUN mkdir -p "$sbt_home/bin"
RUN curl -L "https://cocl.us/sbt-0.13.16.tgz" | tar xz -C /usr/local

WORKDIR /home/jenkins

USER jenkins