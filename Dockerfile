FROM alpine:3.10.3
LABEL maintainer="Moritz Heiber <hello@heiber.im>"

ENV PIWIGO_VERSION="13.8.0" \
  PIWIGO_CHECKSUM="7f6a2a796693a4ce245fd67ebdd8bf873dc6cb1a33acd567104a10347af7fe1d"

RUN set -x && apk --no-cache add curl php7 php7-gd php7-mysqli php7-json php7-session php7-exif mysql-client && \
  curl -Lo /tmp/piwigo.zip "http://piwigo.org/download/dlcounter.php?code=${PIWIGO_VERSION}" && \
  echo "${PIWIGO_CHECKSUM}  /tmp/piwigo.zip" | sha256sum -wsc - && \
  adduser -h /piwigo -DS piwigo && \
  unzip /tmp/piwigo.zip -d /piwigo && \
  install -d -o piwigo /piwigo/piwigo/galleries /piwigo/piwigo/upload && \
  chown -R piwigo /piwigo/piwigo/local && \
  apk --no-cache del curl && \
  rm /tmp/piwigo.zip

WORKDIR /piwigo
USER piwigo

CMD ["php","-S","0.0.0.0:8000","-t","piwigo"]
