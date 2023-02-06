FROM ruby:2.5.7

RUN gem install bundler -v 2.3.26 --no-document

WORKDIR /var/www/scopiform/

ARG ENVIRONMENT=test

CMD ["tail", "-f", "/dev/null"]