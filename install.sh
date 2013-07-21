#! /bin/bash


# Use this at your own risk!
# Credit: http://www.codingsteps.com/install-redis-2-6-on-ubuntu/

basedir=`pwd`
version="redis-2.6.12"
redisdir="$basedir/$version"
ext=".tar.gz"
redistarname="$version$ext"
redistar="$basedir/$redistarname"

# Get redis
wget http://redis.googlecode.com/files/${redistarname}

cd $basedir && tar xzf $redistar

# Install
cd $redisdir && make
cd $redisdir && make install
cd $redisdir && make test

# Create configuration
sudo mkdir /etc/redis
sudo mv redis.conf /etc/redis/redis.conf

# Configure redis as a daemon
echo "daemonize yes" | sudo tee -a /etc/redis/redis.conf
echo "bind 127.0.0.1" | sudo tee -a /etc/redis/redis.conf
echo "dir /var/lib/redis" | sudo tee -a /etc/redis/redis.conf

# Copy binaries to init.d
cd $basedir && sudo cp redis-server $redisdir
cd $redisdir && sudo mv redis-server /etc/init.d/redis-server
sudo chmod +x /etc/init.d/redis-server
cd "$redisdir/src" && sudo cp redis-cli /usr/local/bin/redis-cli
cd "$redisdir/src" && sudo cp redis-server /usr/bin/

echo "DAEMON=/usr/local/bin/redis-server" | sudo tee -a /etc/init.d/redis-server

# Make log files
sudo useradd redis
sudo mkdir -p /var/lib/redis
sudo mkdir -p /var/log/redis
sudo chown redis.redis /var/lib/redis
sudo chown redis.redis /var/log/redis

# Auto-enable redis server
sudo update-rc.d redis-server defaults

# Start redis!
sudo /etc/init.d/redis-server start
