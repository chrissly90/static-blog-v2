# Wget Commandline FU

### Clone entire Websites:
`wget -mkEpnp --convert-links --adjust-extension `

### wget only MP3's:
`wget -e robots=off --no-parent -r --accept '*.mp3' `

### wget via TOR:
 `torsocks wget`

### You can find easily Opendirectories on:

[Reddit](https://www.reddit.com/r/opendirectories/)

[lumpysoft.com](https://lumpysoft.com/)

[http://palined.com/search/](http://palined.com/search/)

### I wrote a bashscript for downloading Opendirectories:

```bash
#!/bin/bash
#
# wmirror <URL> <local-directory-name>
#
# This script is useful for downloading specific file types off of the net.
#
# The following are the base arguments we will be providing to wget.
#   Yes, all of this could be put in a config file.  For the time being
#   I want them here.
#
# --reject "index.html*"   get rid of the index trash
# --cut-dirs 5
# -r                       recursive
# -l inf                   all sub directories
# -np                      do NOT crawl parent directories
# -nH                      do NOT create host directories locally
# -k                       convert links (to refer to local directories)
# -c                       continue (script is restartable)
# -N                       only retrieve files when newer than local file
# -w1                      wait interval is 1 second
# --random-wait            random wait between 0..2 seconds (2 * wait interval)
# --e robots=off           ignore robots.txt (naughty)
## --no-check-certificate   live dangerously
# -a $2.log                append to the log file
 
LOGDIR=$BASEDIR/Logs
URL=$1
DIR=$2
 
if [ ! -d $DIR ]
then
    echo mkdir -p $DIR
    mkdir -p $DIR
fi
 
cd $DIR
wget -r -l inf -np -nH -k -c -N -w1 -e robots=off --random-wait --reject "index.html*" $URL
```
