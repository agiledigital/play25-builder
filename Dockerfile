#
# Play 2.5 Build Image
# Docker image with libraries and tools as required for building Play 2.5 projects using SBT 
#

FROM frolvlad/alpine-oraclejdk8
MAINTAINER Agile Digital <info@agiledigital.com.au>

RUN apk add --update --no-cache bash libsodium curl

ENV sbt_version 0.13.16
ENV sbt_home /usr/local/sbt
ENV PATH ${PATH}:${sbt_home}/bin
ENV HOME /home/jenkins

RUN addgroup -S -g 10000 jenkins
RUN adduser -S -u 10000 -h $HOME -G jenkins jenkins

# Install sbt
RUN mkdir -p "$sbt_home/bin"
RUN curl -sL "http://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$sbt_version/sbt-launch.jar" -o /usr/local/sbt/sbt-launch.jar
ADD sbt /usr/local/sbt/bin/sbt
RUN chmod 0755 /usr/local/sbt/bin/sbt

WORKDIR /home/jenkins

USER jenkins

RUN sbt sbtVersion