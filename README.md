# HappyFeed

![HappyFeed](https://raw.githubusercontent.com/aleks/HappyFeed/master/happyfeed.png)

#### A Fever API compatible RSS Server.

This project is far from finished. I'm working on this in my free time and use it mainly as my own RSS reader/server. If you like to contribute, feel free to send a pull request. If you want to add bigger features or change things, please open an issue or contact me directly. If you just want to talk, you can find me on Twitter [@nd_cmptr](https://twitter.com/nd_cmptr).

[![Build Status](https://travis-ci.org/aleks/HappyFeed.svg?branch=master)](https://travis-ci.org/aleks/HappyFeed)

### Installation

#### Local setup

```
 bundle install
 bundle exec rake db:create db:migrate db:seed
 bundle exec rails s
```

Now go to http://localhost:3000/

#### Docker setup

You should edit the database passwords in docker-compose.yml. This will change in the future, but should be good enough for now.

```
# 1. Clone Repository
git clone git@github.com:aleks/HappyFeed.git happyfeed
cd happyfeed

# 2. Edit .env.production

# 3. Build Image and Start
docker-compose build
docker-compose up # add -d to run in background

# 4. Run Database migration
docker-compose run web bundle exec rake db:create
docker-compose run web bundle exec rake db:migrate
```

### Updating

#### Docker

Go to your HappyFeed directory and do the following:

```
# Stop HappyFeed containers
docker-compose down

# Delete the old containers
docker-compose rm

# Pull updates from GitHub
git pull

# Rebuild both containers
docker-compose build

# Start
docker-compose up

# Run database migrations (there will be no output if nothing changed!)
docker-compose run web bundle exec rake db:migrate
```

```docker-compose.yml``` defines two volumes for db and web, so your database should still be there. This will change, if there is an easy way to export / import subscriptions.

#### Without Docker

Go to your HappyFeed directory and do the following:

```
# Pull updates from GitHub
git pull

# Run database migrations (there will be no output if nothing changed!)
bundle exec rake db:migrate

# Restart your webserver
```

### Usage

If you want to use HappyFeed with a Fever-compatible RSS Reader (ReadKit, Reeder, Unread and many more), use the following address as the "Server Address" and login with your HappyFeed account.

```
http(s)://your-host.tld/fever
```

### Twitter

Want to get notified about new HappyFeed features? Follow [@HappyFeedMe](https://twitter.com/HappyFeedMe) or me [@nd_cmptr](https://twitter.com/nd_cmptr) on Twitter! :)
