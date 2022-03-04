FROM ubuntu:20.04

ARG AUUID="6a9d260e-4ba4-42d2-bc99-14e55c0a147e"
ARG PORT=80

ADD etc/Caddyfile /tmp/Caddyfile
ADD start.sh /start.sh



RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-uvloop python3-cryptography python3-socks libcap2-bin ca-certificates caddy tor wget && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile

RUN setcap cap_net_bind_service=+ep /usr/bin/python3.8

RUN chmod +x /start.sh

COPY mtprotoproxy.py config.py /root/mtprotoproxy/

CMD /start.sh
