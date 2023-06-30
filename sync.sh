#!/bin/bash

echo "Select lineage version"
echo "1. lineageos 14.1"
echo "2. lineageos 15.1"
read -p "Choose your option:[1,2]" input

cd ../
if [[ "$input" == "1" ]]; then
    cd lineage-14.1
elif [[ "$input" == "2" ]]; then
    cd lineage-15.1
fi

echo "Repo sync method"
echo "n. network only"
echo "l. local only"
echo "f. full sync"
read -p "Choose your option:[n,l,F]" input

case $input in  
  n|N) repo sync -n ;; 
  l|L) repo sync -l ;; 
  f|F|"") repo sync ;;
  *) echo dont know ;; 
esac
