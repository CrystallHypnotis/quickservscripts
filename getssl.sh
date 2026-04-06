#!/bin/bash

PORT=80
DOMEN=""


while getopts "d:p:" opt; do
  case ${opt} in
    d )
      DOMEN=$OPTARG
      echo "kekw"
      ;;
    p )
      PORT=$OPTARG
      echo "lol"
      ;;
    \? )
      echo "Неверный флаг\nИспользование: $0 -d <full_domen_name> -p <port_number, default 80>"
      exit 1
      ;;
  esac
done
echo "$DOMEN $PORT used"

if [ "$DOMEN" = "" ]; then
	echo "Домен не указан!"
	echo "Использование: $0 -d <full_domen_name> -p <port_number, default 80>"
	exit 1
fi

echo "Обработка $DOMEN с использованием порта $PORT...."

mkdir -p ~/cert/{$DOMEN}

acme.sh --issue --standalone  -d {$DOMEN} --httpport {$PORT} --key-file ~/cert/{$DOMEN}/privkey.pem --fullchain-file ~/cert/{$DOMEN}/fullchain.pem
