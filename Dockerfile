FROM ruby:2.7

RUN apt-get update

RUN gem install rails bundler
VOLUME ["/app"]
WORKDIR /app
COPY . .
RUN bundle install