# Use Weechat with ZNC

1. `/server add Network public-ip-address/8181 -ssl -username=admin/Network -password=***************** -autoconnect`
2. `/set irc.server.Network.ssl_fingerprint <insert ssl fingerprint (see below)>`
3. `/connect Network`
4. `/save`
 

# Get SSL Fingerprint
`cat ~/.znc/znc.pem | openssl x509 -sha512 -fingerprint -noout | tr -d ':' | tr 'A-Z' 'a-z' | cut -d = -f 2`

# TORify Weechat
## Enable SASL EXTERNAL

    * Create a new certificate TLS. ref
```
    mkdir ~/.weechat/certs
    cd ~/.weechat/certs
    openssl req -x509 -new -newkey rsa:4096 -sha256 -days 1000 -nodes -out freenode.pem -keyout freenode.pem
```
    * Find sha1sum fingerprint.
```
    openssl x509 -in freenode.pem -outform der | sha1sum -b | cut -d' ' -f1
```

## switch to ssl
```
    /msg nickserv cert add e084219c214d391a8fd75cdbb891b5b966515db7
    /set irc.server.freenode.ssl_priorities "NORMAL:-VERS-TLS-ALL:+VERS-TLS1.0:+VERS-SSL3.0:%COMPAT"
    /set irc.server.freenode.ssl_cert "%h/certs/freenode.pem"
    /set irc.server.freenode.sasl_mechanism external
    /set irc.server.freenode.ssl on
    /set irc.server.freenode.addresses "chat.freenode.net/6697"
    /reconnect freenode
```

## TOR
```
    /set irc.server.freenode.addresses "freenodeok2gncmy.onion/7000"
    /proxy add tor socks5 127.0.0.1 9050
    /set irc.server.freenode.proxy "tor"

    You have to disable ssl_verify which doesn’t work with TOR.

    /set irc.server.freenode.ssl_verify off
    /reconnect freenode
```

## Enhance your privacy
```
    /set irc.server_default.msg_part ""
    /set irc.server_default.msg_quit ""
    /set irc.ctcp.clientinfo ""
    /set irc.ctcp.finger ""
    /set irc.ctcp.source ""
    /set irc.ctcp.time ""
    /set irc.ctcp.userinfo ""
    /set irc.ctcp.version ""
    /set irc.ctcp.ping ""
    /plugin unload xfer
    /set weechat.plugin.autoload "*,!xfer"
```

## Save all our works:
```
/save
```
