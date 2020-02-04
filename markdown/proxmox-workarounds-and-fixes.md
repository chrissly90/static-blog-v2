### XMPP Letsencrypt
```bash
pct set 100 -mp0 /mnt/bindmounts/shared,mp=/shared
certbot certonly --webroot -w /var/www/ssl/xmpp --email mail@domain.tld -d xmpp.domain.tld -d conference.domain.tld -d pubsub.domain.tld -d upload.domain.tld -d domain.tld
mountpoint from /etc/letsencrypt/live and /etc/letsencrypt/archive to lxc container (see below)
```

### Fix Locales Debian 10 LXC
```bash
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
```

### Docker under LXC
* Use unprivileged container
* in Options set keyctl=1, nested=1
* systemctl edit containerd.service
* Paste the following:
```bash
[Service]   
ExecStartPre=
```

### Set Local Mountpoint
` pct set 100 -mp0 /etc/letsencrypt/live/..,mp=/etc/letsencrypt/live/... `

### .img to proxmox image (.qcow2)
* move disk as qcow2 to external Storage
* sshfs to storage

`qemu-img convert -f raw -O qcow2 image.img vm-104-disk.qcow2`

* remove old qcow2 image
* remane new qcow2 to old imagename
* move disk to local storage
