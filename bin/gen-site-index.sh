#!/usr/local/bin/bash


cd ../public

tree -H '.' -L 1 --noreport --charset utf-8 -p "*.html"> ../tmp/dir-structure.html
touch structure.html
cat ../src/header.html ../tmp/dir-structure.html ../src/footer.html > structure.html
echo "Successfully created $(pwd)/scructure.html"


for d in ./*/ ; do
    cd "$d";
    tree -H '.' -L 1 --noreport --charset utf-8 > ../../tmp/dir-structure.html
    touch structure.html
    cat ../../src/header.html ../../tmp/dir-structure.html ../../src/footer.html > structure.html
    echo "Successfully created $(pwd)/structure.html"
    cd ..
done
exit 0


