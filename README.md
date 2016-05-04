# HappyFeed
#### A Fever API compatible RSS Server.

This project is far from finished. I'm working on this in my free time and use it mainly as my own RSS reader/server. If you like to contribute, feel free to send a pull request. If you want to add bigger features or change things, please open an issue or contact me directly.

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
docker-compose run web bundle exec rake db:create
docker-compose run web bundle exec rake db:migrate
```

### Usage

If you want to use HappyFeed with a Fever-compatible RSS Reader (ReadKit, Reeder, Unread and many more), use the following address as the "Server Address" and login with your HappyFeed account.

```
http(s)://your-host.tld/fever
```

### Screenshot

![HappyFeed](https://raw.githubusercontent.com/aleks/HappyFeed/master/happyfeed.png)

### Twitter

Want to get notified about new HappyFeed features? Follow [@HappyFeedMe on Twitter](https://twitter.com/HappyFeedMe)!
