FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm AS base

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

# Install main application
RUN apt-get install -y --no-install-recommends freecad

# Install additional libraries
RUN apt-get install -y --no-install-recommends \
  python3-pyside2.qtwebchannel \
  python3-pyside2.qtwebengine* 

# Cleanup
RUN apt-get autoclean && apt-get clean &# rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

FROM base

ENV FILE_NAME=Ondsel_ES_2024.2.0.37191-Linux-x86_64.AppImage

COPY ./dist/$FILE_NAME freecad.AppImage
RUN chmod +x ./freecad.AppImage 
RUN ./freecad.AppImage --appimage-extract
RUN chmod +x ./squashfs-root/AppRun 

# Add local files
COPY /root /

# Set ports and volumes
EXPOSE 3000
VOLUME /config
