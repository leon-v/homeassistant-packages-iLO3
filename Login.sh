#!/usr/bin/env bash

while getopts ":i:u:p:" opt; do
  case $opt in
    i) ip="$OPTARG"
    ;;
    u) username="$OPTARG"
    ;;
    p) password="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

if [ -z "$ip" ]; then
    echo "ip is required. e.g. -i 123.123.123.123"
    exit 1
fi

if [ -z "$username" ]; then
    echo "username is required. e.g. -u Administrator"
    exit 1
fi

if [ -z "$password" ]; then
    echo "password is required. e.g. -p ABC123"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

UseTlsFile="$SCRIPT_DIR/UseTls1.cnf"
if ! [ -f "$UseTlsFile" ]; then
    echo "$UseTlsFile does not exist."
    exit 1
fi

OPENSSL_CONF=$UseTlsFile curl \
    --insecure -X POST https://$ip/json/login_session \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: HomeAssistant" \
    --data "{\"method\": \"login\", \"user_login\":\"$username\", \"password\": \"$password\"}"
