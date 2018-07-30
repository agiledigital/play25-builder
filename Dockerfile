#
# Play 2.5 Build Image
# Docker image with libraries and tools as required for building Play 2.5 projects using SBT 
#

FROM frolvlad/alpine-oraclejdk8
MAINTAINER Agile Digital <info@agiledigital.com.au>
LABEL Description="Docker image with libraries and tools as required for building Play 2.5 projects using SBT " Vendor="Agile Digital" Version="0.1"

RUN apk add --update --no-cache bash libsodium curl linux-pam binutils \
    && curl -Ls https://www.archlinux.org/packages/core/x86_64/gcc-libs/download > /tmp/gcc-libs.tar.xz \
    && mkdir /tmp/gcc \
    && tar -xf /tmp/gcc-libs.tar.xz -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && curl -Ls https://www.archlinux.org/packages/core/x86_64/zlib/download > /tmp/libz.tar.xz \
    && mkdir /tmp/libz \
    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
    && apk del binutils \
    && rm -rf /tmp/gcc /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

ENV sbt_version 0.13.16
ENV sbt_home /usr/local/sbt
ENV PATH ${PATH}:${sbt_home}/bin
ENV HOME /home/jenkins

RUN addgroup -S -g 10000 jenkins
RUN adduser -S -u 10000 -h $HOME -G jenkins jenkins

# We need to support Openshift's random userid's
# Openshift leaves the group as root. Exploit this to ensure we can always write to them
# Ensure we are in the the passwd file
RUN chmod g+w /etc/passwd
RUN chgrp -Rf root /home/jenkins && chmod -Rf g+w /home/jenkins
ENV JENKINS_USER jenkins

# Install sbt
RUN mkdir -p "$sbt_home/bin"
RUN curl -L "https://cocl.us/sbt-0.13.16.tgz" | tar xz -C /usr/local

WORKDIR /home/jenkins

USER jenkins
