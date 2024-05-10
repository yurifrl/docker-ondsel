FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# Set version label and maintainer
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# Environment Variables
ENV TITLE=FreeCAD

# Adding the FreeCAD icon
RUN curl -o /kclient/public/icon.png https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/freecad-logo.png

# Setup
RUN apt-get update

# Install additional libraries
RUN apt-get install -y --no-install-recommends \
  python3-pyside2.qtwebchannel \
  python3-pyside2.qtwebengine* 

# Cleanup
RUN apt-get autoclean && apt-get clean &# rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

WORKDIR /usr/local/src/

ENV FILE_NAME=Ondsel_ES_2024.2.0.37191-Linux-x86_64.AppImage

COPY ./dist/$FILE_NAME /usr/local/src/freecad.AppImage

RUN chmod +x /usr/local/src/freecad.AppImage 
RUN /usr/local/src/freecad.AppImage --appimage-extract
RUN chmod +x /usr/local/src/squashfs-root/AppRun 

COPY /root /

EXPOSE 3000
VOLUME /config
