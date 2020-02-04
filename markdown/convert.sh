#!/bin/bash

if [[ $# -eq 0 ]] ; then
	echo "Usage: <inputfile> <newfilename>";
	echo "or:    <inputfile> <newfilename> <category>";
	echo "possible categories:"
    echo "$(ls --color ../public/ | grep -v ../public/css/style.css |grep -v ../public/index.html)";
    exit 0;
fi



pandoc --to=html --from=markdown -o ../tmp/tmp.html "$1";
cat ../src/header.html ../tmp/tmp.html ../src/footer.html > ../public/posts/$2;

if [ "$#" -ne 3 ]
    then
        echo "file public/posts/$2 successfully created";
    else
	    mv ../public/posts/$2 ../public/$3/$2;
        echo "successfully created time public/$3/$2";

fi

exit 0
