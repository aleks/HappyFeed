FROM phusion/passenger-ruby22:0.9.15

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --jobs=3 --retry=3

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
ADD config/docker/nginx-site.conf /etc/nginx/sites-enabled/happyfeed.conf
ADD config/docker/nginx.conf /etc/nginx/main.d/happyfeed-setup.conf

RUN mkdir /home/app/happyfeed
ADD . /home/app/happyfeed
RUN chown -R app:app /home/app/happyfeed

WORKDIR /home/app/happyfeed
RUN sudo -u app RAILS_ENV=production bin/rake assets:precompile

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
