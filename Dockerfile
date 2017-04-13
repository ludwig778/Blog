FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libmagickwand-dev libsqlite3-dev libpq-dev ruby-full
RUN mkdir /blog
WORKDIR /blog
ADD Gemfile /blog/Gemfile
ADD Gemfile.lock /blog/Gemfile.lock
RUN bundle install
ADD . /blog
CMD ["bash", "/blog/launch.sh"]
