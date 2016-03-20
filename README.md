# HappyFeed
#### A Fever API compatible RSS Server.

More Info soon. :)

[![Build Status](https://travis-ci.org/aleks/HappyFeed.svg?branch=master)](https://travis-ci.org/aleks/HappyFeed)

### Local setup

```
 bundle install
 bundle exec rake db:create db:migrate db:seed
 bundle exec rails s
```

Now go to http://localhost:3000/

### Docker setup

You should edit the database passwords in docker-compose.yml. This will change in the future, but should be good enough for now.

```
# Clone Repository
git clone git@github.com:aleks/HappyFeed.git happyfeed
cd happyfeed

# Build Image and Start
docker-compose build
docker-compose up

# Run Database migration
docker-compose run web bundle exec rake db:migrate
```
