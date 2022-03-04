#!/bin/sh

tor &
python3 /root/mtprotoproxy/mtprotoproxy.py &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
