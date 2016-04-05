FROM phusion/passenger-full:0.9.18

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install --jobs=3 --retry=3

# Setup Nginx config
RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
COPY config/docker/nginx-site.conf /etc/nginx/sites-enabled/happyfeed.conf
COPY config/docker/nginx.conf /etc/nginx/main.d/happyfeed-setup.conf

# Add self-signed certificate with a randomly generated key
COPY config/docker/openssl.conf /etc/nginx/ssl/openssl.conf
RUN mkdir -p /etc/nginx/ssl/ \
    && cd /etc/nginx/ssl/ \
    && SSL_PASS=$(openssl rand -base64 30) \
    && openssl genrsa -des3 -out server.key -passout pass:$(echo $SSL_PASS) 1024 \
    && openssl req -config openssl.conf -new -key server.key -out server.csr -passin pass:$(echo $SSL_PASS) \
    && cp server.key server.key.org \
    && openssl rsa -in server.key.org -out server.key -passin pass:$(echo $SSL_PASS) \
    && openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt \
    && openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

RUN mkdir /home/app/happyfeed
COPY . /home/app/happyfeed
RUN chown -R app:app /home/app/happyfeed

WORKDIR /home/app/happyfeed

# Compile assets
RUN sudo -u app RAILS_ENV=production bin/rake assets:precompile

# Add cronjob
COPY config/docker/happyfeed-cron /etc/cron.d/happyfeed-cron
RUN chmod +x /etc/cron.d/happyfeed-cron

# Enable Redis
RUN rm -f /etc/service/redis/down

# Add Sidekiq to runit services
RUN mkdir /etc/service/sidekiq
ADD config/docker/sidekiq-runit /etc/service/sidekiq/run
RUN chmod +x /etc/service/sidekiq/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
