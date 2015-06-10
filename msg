#!/bin/bash

# telegram-cli path
TELEGRAM_CLI_PATH=$HOME/telegram-cli
TELEGRAM_CLI_BIN=$TELEGRAM_CLI_PATH/telegram-cli
TELEGRAM_CLI_KEY=$TELEGRAM_CLI_PATH/tg-server.pub

# parameter check
if [ -z $1 ]; then
  >&2 echo "ERROR: Receiver isn't provided."
  exit 1
fi

# read message from stdin
MSG=`tee | sed ':a;N;$!ba;s/\n/\\\\n/g;s/\x22/\\\\\x22/g'`

# send message
eval `echo $TELEGRAM_CLI_BIN -k $TELEGRAM_CLI_KEY -WR -e \'msg $1 \"$MSG\"\'`

