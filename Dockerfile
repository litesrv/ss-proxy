FROM shadowsocks/shadowsocks-libev:latest

ENV SERVER_ADDR=0.0.0.0
ENV SERVER_PORT=8388
ENV PASSWORD=
ENV METHOD=aes-256-gcm
ENV TIMEOUT=300
ENV ARGS=
ENV LOCAL_PORT=1080

USER root

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apk add --no-cache privoxy curl perl \
    && curl -skL https://raw.github.com/zfl9/gfwlist2privoxy/master/gfwlist2privoxy -o gfwlist2privoxy \
    && sh gfwlist2privoxy '127.0.0.1:1080' \
    && mv -f gfwlist.action /etc/privoxy \
    && cp /etc/privoxy/config.new /etc/privoxy/config \
    && cp /etc/privoxy/default.filter.new /etc/privoxy/default.filter \
    && cp /etc/privoxy/user.filter.new /etc/privoxy/user.filter \
    && cp /etc/privoxy/match-all.action.new /etc/privoxy/match-all.action \
    && cp /etc/privoxy/default.action.new /etc/privoxy/default.action \
    && cp /etc/privoxy/user.action.new /etc/privoxy/user.action \
    && echo 'actionsfile gfwlist.action' >>/etc/privoxy/config \
    && sed -i 's/listen-address\s\+127.0.0.1:8118/listen-address 0.0.0.0:8118/' /etc/privoxy/config

CMD ["docker-entrypoint.sh"]