# dd /dev/sda image to ssh target

1. we get the current date and time for backup naming  
`echo $(hostname)-$(date +%d-%m-%Y"-"%H:%M:%S)`
2. on **Client** issue (don't forget to enter .gz as file extension):  
`    dd if=/dev/sda | gzip -1 - | ssh root@nas dd of=/path/to/image/on/nas/output-from-step-1.gz`
3. on **Backup Server** issue:  
`ssh root@client "dd if=/dev/sda | gzip -1 -" | dd of=/path/to/image/on/nas/output-from-step-1.gz`
4. to get data on progress issue on **Client**:  
`pkill -USR1 dd`

# Backup Rootserver

### backup.sh
```
#!/bin/bash

SERVER=$(hostname -s)
REMOTE="opendrive-sina:${SERVER}"
FILTER="/root/filter.txt"
LOGFILE="/root/backup.sh.log"
VERBOSE="-v"                # Add more v's for more verbosity
VERSIONS=20                  # Number of backup versions to keep

# Purge oldest version
VERSION=$VERSIONS
rclone purge ${REMOTE}/old${VERSION} ${VERBOSE}

# Make room for a new backup version
while [ $VERSION -gt 1 ]; do
  (( OLDV=$VERSION-1 ))
  rclone move ${REMOTE}/old${OLDV} ${REMOTE}/old${VERSION} ${VERBOSE}
  (( VERSION = $OLDV ))
done

# Perform backup
rclone -L ${VERBOSE} --log-file=${LOGFILE} sync /etc/letsencrypt/ ${REMOTE}/letsencrypt/
rclone -L ${VERBOSE} --log-file=${LOGFILE} sync /etc/nginx/ ${REMOTE}/nginx/
rclone  ${VERBOSE} --log-file=${LOGFILE} sync /etc/network/interfaces ${REMOTE}/etc/
rclone ${VERBOSE} --log-file=${LOGFILE} sync /var/lib/vz/dump/ ${REMOTE}/recent --backup-dir ${REMOTE}/old1 --skip-links
```

# NAS backup.sh
```
#!/bin/bash
# Simple backup with rsync
# local-mode, tossh-mode, fromssh-mode

SOURCES=(/root /etc /home /var/lib/vz/ /boot /storage )
TARGET="/media/data/backup"

# edit or comment with "#"
#LISTPACKAGES=listdebianpackages        # local-mode and tossh-mode
MONTHROTATE=20                 # use DD instead of YYMMDD

RSYNCCONF=(--exclude=/storage/shares/privat/{'Anime/*','backup/*','Filme/*','Filme Englisch/*','Games/*','Musik/*','Musik Videos/*','Serien/*'} --exclude='/storage/shares/backup/*')
MOUNTPOINT="/media/data"               # check local mountpoint
MAILREC="aaccount@nchristian.net"

#SSHUSER="sshuser"
#FROMSSH="fromssh-server"
#TOSSH="tossh-server"
# SSHPORT=22

### do not edit ###

MOUNT="/bin/mount"; FGREP="/bin/fgrep"; SSH="/usr/bin/ssh"
LN="/bin/ln"; ECHO="/bin/echo"; DATE="/bin/date"; RM="/bin/rm"
DPKG="/usr/bin/dpkg"; AWK="/usr/bin/awk"; MAIL="/usr/bin/mail"
CUT="/usr/bin/cut"; TR="/usr/bin/tr"; RSYNC="/usr/bin/rsync"
LAST="last"; INC="--link-dest=$TARGET/$LAST"


LOG=$0.log
$DATE > $LOG

if [ "${TARGET:${#TARGET}-1:1}" != "/" ]; then
  TARGET=$TARGET/
fi

if [ "$LISTPACKAGES" ] && [ -z "$FROMSSH" ]; then
  $ECHO "$DPKG --get-selections | $AWK '!/deinstall|purge|hold/'|$CUT -f1 | $TR '\n' ' '" >> $LOG
  $DPKG --get-selections | $AWK '!/deinstall|purge|hold/'|$CUT -f1 |$TR '\n' ' '  >> $LOG  2>&1
fi

if [ "$MOUNTPOINT" ]; then
  MOUNTED=$($MOUNT | $FGREP "$MOUNTPOINT");
fi

if [ -z "$MOUNTPOINT" ] || [ "$MOUNTED" ]; then
  if [ -z "$MONTHROTATE" ]; then
    TODAY=$($DATE +%y%m%d)
  else
    TODAY=$($DATE +%d)
  fi

  if [ "$SSHUSER" ] && [ "$SSHPORT" ]; then
    S="$SSH -p $SSHPORT -l $SSHUSER";
  fi

  for SOURCE in "${SOURCES[@]}"
    do
      if [ "$S" ] && [ "$FROMSSH" ] && [ -z "$TOSSH" ]; then
        $ECHO "$RSYNC -e \"$S\" -avR \"$FROMSSH:$SOURCE\" ${RSYNCCONF[@]} $TARGET$TODAY $INC"  >> $LOG
        $RSYNC -e "$S" -avR "$FROMSSH:\"$SOURCE\"" "${RSYNCCONF[@]}" "$TARGET"$TODAY $INC >> $LOG 2>&1
        if [ $? -ne 0 ]; then
          ERROR=1
        fi
      fi
      if [ "$S" ]  && [ "$TOSSH" ] && [ -z "$FROMSSH" ]; then
        $ECHO "$RSYNC -e \"$S\" -avR \"$SOURCE\" ${RSYNCCONF[@]} \"$TOSSH:$TARGET$TODAY\" $INC " >> $LOG
        $RSYNC -e "$S" -avR "$SOURCE" "${RSYNCCONF[@]}" "$TOSSH:\"$TARGET\"$TODAY" $INC >> $LOG 2>&1
        if [ $? -ne 0 ]; then
          ERROR=1
        fi
      fi
      if [ -z "$S" ]; then
        $ECHO "$RSYNC -avR \"$SOURCE\" ${RSYNCCONF[@]} $TARGET$TODAY $INC"  >> $LOG
        $RSYNC -avR "$SOURCE" "${RSYNCCONF[@]}" "$TARGET"$TODAY $INC  >> $LOG 2>&1
        if [ $? -ne 0 ]; then
          ERROR=1
        fi
      fi
  done

  if [ "$S" ] && [ "$TOSSH" ] && [ -z "$FROMSSH" ]; then
    $ECHO "$SSH -p $SSHPORT -l $SSHUSER $TOSSH $LN -nsf $TARGET$TODAY $TARGET$LAST" >> $LOG
    $SSH -p $SSHPORT -l $SSHUSER $TOSSH "$LN -nsf \"$TARGET\"$TODAY \"$TARGET\"$LAST" >> $LOG 2>&1
    if [ $? -ne 0 ]; then
      ERROR=1
    fi
  fi
  if ( [ "$S" ] && [ "$FROMSSH" ] && [ -z "$TOSSH" ] ) || ( [ -z "$S" ] );  then
    $ECHO "$LN -nsf $TARGET$TODAY $TARGET$LAST" >> $LOG
    $LN -nsf "$TARGET"$TODAY "$TARGET"$LAST  >> $LOG 2>&1
    if [ $? -ne 0 ]; then
      ERROR=1
    fi
  fi
else
  $ECHO "$MOUNTPOINT not mounted" >> $LOG
  ERROR=1
fi
$DATE >> $LOG
if [ -n "$MAILREC" ]; then
  if [ $ERROR ];then
    $MAIL -s "Error Backup $LOG" $MAILREC < $LOG
  else
    $MAIL -s "Backup $LOG" $MAILREC < $LOG
  fi
fi


```
