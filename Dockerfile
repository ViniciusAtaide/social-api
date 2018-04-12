FROM ruby:2.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libcurl4-gnutls-dev patch ruby-dev zlib1g-dev liblzma-dev libgmp-dev
RUN mkdir /code
WORKDIR /code
COPY Gemfile* /code/
RUN bundle install
COPY . .
