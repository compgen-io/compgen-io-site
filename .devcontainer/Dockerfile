FROM debian:10

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

#ARG USERNAME=user
#ARG USER_UID=1000
#ARG USER_GID=$USER_UID


RUN apt-get update \
    && apt-get install -y gem ruby ruby-dev make gcc g++ nodejs vim libz-dev patch git \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && gem install jekyll bundler \
    && gem install just-the-docs --version '>=0.2.8' \
    && mkdir /data

ENV DEBIAN_FRONTEND=dialog

EXPOSE 4000/tcp
VOLUME /data
#WORKDIR /data

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

#ENTRYPOINT [ "bundle", "exec", "jekyll", "serve", "-H", "0.0.0.0" ]
#ENTRYPOINT /bin/bash
