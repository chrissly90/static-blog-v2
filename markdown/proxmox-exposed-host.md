In This Post I'm showing you How to create a Proxmox host which is reachable trough internet. It presupposes you have Proxmox already installed on your server:

## 1. Access and Update the Server

1. Create and copy your SSH Key
2. Connect with SSH Key
3. Upgrade Server

```bash
apt-get update && apt-get dist-upgrade -y

```
-------------------------------------------------------------------------

## 2. Harden SSH:

1. Unstall UFW
2. Allow Port 22 (SSH Port) with Protocol TCP
3. Reload and activate UFW
4. Add User
5. install sudo
6. Add new user to sudo Group

```bash
apt-get install ufw
ufw allow 22/tcp
ufw enable
adduser yourusername
apt-get install sudo
sudo adduser mynewuser sudo
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

## 3. Geoblocking unwanted Visitors:

- Geoblock with:
[Russian Blocklist / China Blocklist](https://git.tinfoil-hat.net/tinfoil-hat/ip-backlist-china-and-russia)

## Attention: Run in screen, this takes a large amount of time!
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

## 4. (Optional) Make SSH Port accessable only via VPN Connection or your Static IP:

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

9. edit /etc/network/interfaces

```bash
nano /etc/network/interfaces
```
- Add the following Text under your main Interface:

```bash
	post-up echo 1 > /proc/sys/net/ipv4/ip_forward
```

- *This line will also allow you to access the Internet when connected trough your VPN*

-------------------------------------------------------------------------

## 5. Convert yor Debian 10 Server to Proxmox 6

1. Add an /etc/hosts entry for your IP address
   * Note: Make sure that no IPv6 address for your hostname is specified in /etc/hosts. 
   * For instance, if your IP address is 192.168.15.77, and your hostname prox4m1, then your /etc/hosts file should look like: 
   
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

## Now Reboot:

```bash
reboot
```

-------------------------------------------------------------------------

## 6. Enter Proxmox Management UI

1. Allow the Proxmox management Port (8006) to be open
2. Reload UFW
3. After that your Management Web Interface should be reachable in your Browser under https://your-ip-address:8006/

```bash
ufw allow 8006/tcp
ufw reload
```

-------------------------------------------------------------------------

## 6. Configure Proxmox

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

## Now Reboot:
```bash
reboot
```

- Your Network Configuration in your Web Interface Should now look something like this:

[![Screenshot-from-2019-10-23-04-06-56.png](https://wiki.tinfoil-hat.net/uploads/images/gallery/2019-10/scaled-1680-/Screenshot-from-2019-10-23-04-06-56.png)](/uploads/proxmox-bridge.png)

# To be continued ...
