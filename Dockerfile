FROM phusion/passenger-ruby22:0.9.15

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install --jobs=3 --retry=3

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
COPY config/docker/nginx-site.conf /etc/nginx/sites-enabled/happyfeed.conf
COPY config/docker/nginx.conf /etc/nginx/main.d/happyfeed-setup.conf

RUN mkdir /home/app/happyfeed
COPY . /home/app/happyfeed
RUN chown -R app:app /home/app/happyfeed

WORKDIR /home/app/happyfeed

# Compile assets
RUN sudo -u app RAILS_ENV=production bin/rake assets:precompile

# Add cronjob
RUN echo "*/5 * * * * app /bin/bash -l -c 'cd /home/app/happyfeed/ && /usr/bin/ruby -- bin/rails runner -e production '\''FeedFetcher.fetch_all'\'''" >> /etc/cron.d/happyfeed

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
