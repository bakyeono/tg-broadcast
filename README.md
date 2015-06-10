tg-broadcast
============

[한국어 문서 보기](https://github.com/bakyeono/tg-broadcast/blob/master/README-ko.md)

**tg-broadcast** is a Telegram broadcast & auto response script (a.k.a. robot) for [telegram-cli(unofficial)][telegram-cli].

There are a few Telegram bot scripts out there. Go find one that fits you. If you want to broadcast messages with Telegram, I recommend to use this script.

tg-broadcast is tested on telegram-cli 1.3.1.

GitHub repository: https://github.com/bakyeono/tg-broadcast

## Features

### Broadcast

You can broadcast to multiple subscribers. Your friends can subscribe or unsubscribe by simply sending a message to you.

### Scripted response

Any `stdout` omitting program can be used to send reply message. Adding new response rules is easy.

### DBMS / no DBMS

Use SQLite, MySQL, MariaDB, or just text files for subscriber management.

## Install

### Install telegram-cli (if you didn't already)

Clone and compile telegram-cli. Follow the instruction in [telegram-cli(unofficial)][telegram-cli] page.

    $ cd ~
    $ git clone --recursive git@github.com:vysheng/tg.git
    $ cd tg
    $ sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev
    $ ./configure
    $ make

Done? Copy the compiled binary and key file into `~/telegram-cli`

    $ mkdir ~/telegram-cli
    $ cp bin/telegram-cli tg-server.pub ~/telegram-cli

Now you can run telegram-cli. Run it first time and do the authorization.

    $ cd ~/telegram-cli
    $ ./telegram-cli

Type "help" on the telegram-cli prompt to see available commands.

### Install tg-broadcast

Clone this repo into your home.

    $ cd ~
    $ git clone git@github.com:bakyeono/tg-broadcast.git
    $ cd tg-broadcast

Install SQLite3. (Recommended. If you don't want use SQLite3, see `config.lua`.)

    $ sudo apt-get install sqlite3

## Run

Now you can run the script:

    $ ~/tg-broadcast/test   # run REPL mode
    $ ~/tg-broadcast/start  # run daemon mode
    $ ~/tg-broadcast/stop   # kill running telegram-cli process

When the script is running, send `help` message to yourself and you'll get this reply:

    help        : This help
    ip          : Server's IP address
    time        : Server's time
    calendar    : Calendar
    weather CITY: Weather for CITY
    subscribe   : Subscribe my news
    unsubscribe : Unsubscribe my news
    -------------------------
    (admin only)
    broadcast   : Force broadcast now
    notify      : Send a message to subscribers
    safequit    : Turn off robot

Now edit `config.lua` to edit broadcast message and add your own commands to the robot.


[telegram-cli]: https://github.com/vysheng/tg


