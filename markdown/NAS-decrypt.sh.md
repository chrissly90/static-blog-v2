# Decrypt NAS

```
#!/bin/bash

echo -n type passphrase
read -s pass

echo -n $pass | sudo cryptsetup luksOpen /dev/sda1 hdd1  -d -
echo -n $pass | sudo cryptsetup luksOpen /dev/sdb1 hdd2  -d -
echo -n $pass | sudo cryptsetup luksOpen /dev/sdc1 hdd3  -d -
echo -n $pass | sudo cryptsetup luksOpen /dev/sdd1 hdd4  -d -

zpool import -f storage
zpool status storage
zfs mount storage/shares
zfs mount storage/pve

#sudo mount /dev/mapper/sdc1 /data/crypt
#sudo mount /dev/mapper/sdy1 /data/crimeplans
#sudo mount /dev/mapper/sdz1 /data/sonydownloads

#echo SSD Partitions Attached - press enter
pass=/dev/uradom
exit 0
```
