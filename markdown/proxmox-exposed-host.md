s Post I'm showing you How to create a Proxmox host which is reachable trough internet. It presupposes you have Debian already installed on your server:

#### 1. Access and Update the Server

1. Add User
2. install sudo
3. Add new user to sudo Group
4. Create and copy your SSH Key -> [Creating a SSH-key](https://wiki.tinfoil-hat.net/books/ssh/page/creating-a-ssh-key)
5. Connect with SSH Key
6. Upgrade Server
```bash
adduser yourusername
apt-get install sudo
sudo adduser mynewuser sudo
apt-get update && apt-get dist-upgrade -y
```

-------------------------------------------------------------------------

#### 2. Harden SSH:

1. Install UFW
2. Allow Port 22 (SSH Port) with Protocol TCP
3. Reload and activate UFW



```bash
apt-get install ufw
ufw allow 22/tcp
ufw enable
nano /etc/ssh/sshd_config
```
- Now edit / instert the following

```bash
PermitRootLogin no
MaxAuthTries 6
AllowUsers yourusername
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes
```
- Now reload SSH via:

```bash
systemctl restart sshd
```

-------------------------------------------------------------------------

#### 3. Geoblocking unwanted Visitors:

- Geoblock with:
[Russian Blocklist / China Blocklist](https://git.tinfoil-hat.net/tinfoil-hat/ip-backlist-china-and-russia)

##### Attention: Run in screen, this takes a large amount of time!
1. Install screen and git
2. Copy blacklist sources
3. Change directory to copied Sources
4. Create Screen session (if SSH session is interrupted the command doesn't cancel)
5. This is a while loop in Bash and will deny the connections from the IP adresses in this file.  This step may take 1 to 2 hours to complete.
	* After you executed the command, you can send Screen to the Background with: CTRL+a+d


```bash
apt-get install screen git
git clone https://git.tinfoil-hat.net/tinfoil-hat/ip-backlist-china-and-russia
cd ip-backlist-china-and-russia/
screen -S blocklist
while read line; do sudo ufw deny from $line; done < blocklist.txt && bash block_china_ufw.sh
```

-------------------------------------------------------------------------

#### 4. Convert your Debian 10 Server to Proxmox 6

1. Add an /etc/hosts entry for your IP address
   * Note: Make sure that no IPv6 address for your hostname is specified in /etc/hosts
   * For instance, if your IP address is 192.168.15.77, and your hostname prox4m1, then your /etc/hosts file should look like: 

```bash
nano /etc/hosts
```

```bash
127.0.0.1       localhost.localdomain localhost
192.168.15.77   prox4m1.proxmox.com prox4m1

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

* You can test if your setup is ok using the hostname command: 
```bash
hostname --ip-address
192.168.15.77 # should return your IP address here
```

2. Adapt your sources.list
* Add the Proxmox VE repository:
```bash
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
```

3. Add the Proxmox VE repository key: 
```bash
wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg  # optional, if you have a non-default umask
```

4. Update your repository and system by running: 
```bash
apt update && apt full-upgrade
```

5. Install the Proxmox VE packages 
```bash
apt install proxmox-ve postfix open-iscsi
```

6. Recommended: remove the os-prober package
   * The os-prober package scans all the partitions of your host, including those assigned to guests VMs, to create dual-boot GRUB entries. If you didn't install Proxmox VE as dual boot beside another Operating System, you can safely remove the os-prober package.
```bash
apt remove os-prober
```

7. Update and check grub2 config by running:
```bash
update-grub
```

##### Now Reboot:
```bash
reboot
```

-------------------------------------------------------------------------

#### 5. Enter Proxmox Management UI

1. Allow the Proxmox management Port (8006) to be open
2. Reload UFW
3. After that your Management Web Interface should be reachable in your Browser under https://your-ip-address:8006/

```bash
ufw allow 8006/tcp
ufw reload
```

-------------------------------------------------------------------------

#### 6. Configure Proxmox

1. Edit the file /etc/network/interfaces
  - Paste the following (if your Main Interface is eth0)
  - Notice that I moved the Part *post-up echo 1 > /proc/sys/net/ipv4/ip_forward*  now from the Hardware Interface to the newly created Linux Bridge (vmbr1)
  
```bash
auto vmbr1
iface vmbr1 inet static
        address  10.10.10.254
        netmask  255.255.255.0
        bridge-ports none
        bridge-stp off
        bridge-fd 0

        dns-nameservers 208.67.222.222 208.67.220.220

        post-up echo 1 > /proc/sys/net/ipv4/ip_forward

        post-up iptables -t nat -A POSTROUTING -s '10.10.10.0/24' -o eth0 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.10.10.0/24' -o eth0 -j MASQUERADE
```

##### Now Reboot:
```bash
reboot
```

- Your Network Configuration in your Web Interface Should now look something like this:

[![Screenshot-from-2019-10-23-04-06-56.png](media/Screenshot-from-2019-10-23-04-06-56.png)

-------------------------------------------------------------------------

#### 7. (Optional) Make SSH Port accessable only via VPN Connection or your Static IP:

1. Use / download Openvpn script:
[angristan/openvpn-install](https://github.com/angristan/openvpn-install)
2. Change directory to Openvpn script
3. Make script executable
4. run Openvpn script
5. Allow SSH traffic from your OpenVPN connection
6. Allow SSH traffic from your Static IP Address (if you have one at home)
7. Change loglevel of your UFW so that the logfiles don't get gigantic.
8. Edit /etc/default/ufw

```bash
git clone https://github.com/angristan/openvpn-install
cd openvpn-install/
chmod +x openvpn-install.sh
./openvpn-install.sh
ufw allow from  10.8.0.0/24  to any port 22
ufw allow from  *staticip*  to any port 22
ufw logging low
nano /etc/default/ufw
```

- Allow troughput trough your VPN Connection and avoid getting no internet connection when you are connected with your VPN

```bash
DEFAULT_FORWARD_POLICY="ACCEPT"
```

9. reload ufw

```bash
ufw reload
```

10. test VPN connection and ssh connection to yourusername@10.10.10.254
11. if EVERYTHING works, continue with 12.
12. remove firewall rule to allow connection to port 22/tcp
13. reload ufw

```bash
ufw delete allow 22/tcp
ufw reload
```

14. The Only way to connect now to your server is either via your (if you have one) static IP or trough your VPN connection.


-------------------------------------------------------------------------

#### 8. Fix Locales Error

- Copy paste the Commands, I also just googled them, and I'm not exactly sure what the Commands are exactly doing, besides, fixing the locales...

```bash
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
```

-------------------------------------------------------------------------

##### 9. Now we are pasting the right (no-subscription) Proxmox Apt-Repository. Since we don't have a Subscription and we don't want one (most of the time...)

1. First we remove the file /etc/apt/sources.list.d/pve-enterprise.list
```bash
rm /etc/apt/sources.list.d/pve-enterprise.list
```

2. Then we create a new file named pve-no-subscription.list via nano:

```bash
nano /etc/apt/sources.list.d/pve-no-subscription.list
```

3. there we paste simply the following, which has no deeper meaning, besides, it's the Proxmox no subscription Repository

```bash
deb http://download.proxmox.com/debian/pve buster pve-no-subscription
```

4. test if your repositories are correctly set up with updating your Server:

```bash
apt-get update
```

5. if there are no error messages, your repositories are correctly setup
 
# Create a Template

## The special case with a VPS

### Container

in most cases a VPS has only one virtual drive attached, what makes it impossible (if the VPS uses LVM) for Proxmox to create a template, since the template needs to be on another Storage (correct me, if it changed in meantime). So what you do instead is download a LXC Template from the GUI, assign it the last possible IP you have and costumize it. This has several advantages:

- the first Container has the id 0, if it's your template, the first Container can be assigned with your IP X.X.X.1
- you can simply clone your fist Container via GUI even tough it's no "real" Template

**Note:** This is more or less a workaround, since if you have f.e. ZFS as storage, you CAN create templates. Netherless, it is good practice to use your first created container / VM as template, since it's easier, to assign your IP addresses in order.


# Create a reverse Proxy

## Install a webserver

in this case we are using a Nginx webserver

```apt-get install nginx```

## Configure nginx
for Nginx configuration I am linking a sample Nginx configuration linked with my git:

[https://git.tinfoil-hat.net/tinfoil-hat/nginx-reverse-proxy-conf](https://git.tinfoil-hat.net/tinfoil-hat/nginx-reverse-proxy-conf)                                                      

## test Nginx configuration for mistakes

```nginx -t```

## restart Nginx

```systemctl restart nginx```

### ... enjoy your nginx reverse proxy

