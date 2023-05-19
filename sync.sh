#!/bin/bash

echo "Repo sync method"
echo "n. network only"
echo "l. local only"
echo "f. full sync"
read -p "Choose your option:" input

case $input in  
  n|N) repo sync -n ;; 
  l|L) repo sync -l ;; 
  f|F) repo sync ;;
  *) echo dont know ;; 
esac
