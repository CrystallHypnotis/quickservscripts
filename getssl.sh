#!/bin/bash

PORT=80
DOMEN=""

while getopts "d:p:" opt; do
  case ${opt} in
    d )
      DOMEN=$OPTARG
      ;;
    p )
      PORT=$OPTARG
      ;;
    \? )
      echo "Использование: $0 -d <домен> -p <порт>"
      exit 1
      ;;
  esac
done

if [ -z "$DOMEN" ]; then
  echo "Домен не указан!"
  echo "Использование: $0 <domen> -p <port, default 80>"
  exit 1
fi

echo "Обработка $DOMEN с использованием порта $PORT...."

if [[ -n "$(ss - tulpn | grep ":$(PORT)")" ]]; then
  echo "Указанный порт занят!"
  echo "Использование: $0 <domen> -p <port, default 80>"
  exit 1
fi

mkdir -p ~/cert/${DOMEN}

~/.acme.sh/acme.sh --issue --standalone -d "$DOMEN" --httpport "$PORT" --keylength ec-256

~/.acme.sh/acme.sh --install-cert -d "$DOMEN" \
    --key-file ~/cert/"$DOMEN"/privkey.pem \
    --fullchain-file ~/cert/"$DOMEN"/fullchain.pem 

echo "Готово! Сертификат для $DOMEN будет обновляться автоматически."