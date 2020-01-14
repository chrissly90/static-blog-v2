#!/bin/bash

cd ../markdown

for i in *; do
    ./convert.sh $i "$(echo $i | cut -f 1 -d '.').html"
done

cd ../bin

exit 0
