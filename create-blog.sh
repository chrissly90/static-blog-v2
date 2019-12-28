#!/usr/local/bin/bash
cd bin

./gen-post-html.sh
./gen-site-index.sh
./symlinks.sh
cd ..
