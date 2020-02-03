FROM ruby:2.6.5-buster
LABEL author="Gueorgui Tcherednitchenko"
LABEL version="1.0.0"

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV BUNDLER_VERSION 2.0.2
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nodejs \
    git \
    && gem install bundler:2.0.2 \
    && bundle config --global silence_root_warning 1

COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
