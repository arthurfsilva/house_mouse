FROM ruby
COPY . /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN cd /app && bundle install
CMD /bin/bash