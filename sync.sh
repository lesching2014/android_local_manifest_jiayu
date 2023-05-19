read -p "Do you want to sync NOW? [Y,n]" -i Y input
if [[ $input == "Y" || $input == "y" ]]; then
    repo sync 
fi
echo "Repo sync method"
echo "n. network only"
echo "l. local only"
echo "f. full sync"
read "Choose ?" input

case $input in  
  n|N) repo sync -n ;; 
  l|L) repo sync -l ;; 
  f|F) repo sync ;;
  *) echo dont know ;; 
esac
