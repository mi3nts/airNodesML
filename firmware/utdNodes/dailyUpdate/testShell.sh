#!/bin/bash

target_date="Jan 1 2019"
today=`echo $(($(date --utc --date "$1" +%s)/86400))`
target=`echo $(($(date --utc --date "$target_date" +%s)/86400))`
days=`expr $today - $target`
echo "$days days until $target_date"

d=1
while [ "$d" != $days ]; do 

  echo  nodeIndex $1
  echo  Days Back $d
  echo  "------------"

  matlab -nodisplay -nosplash -nodesktop -batch 'try dailyUpdate('$1','$d'); catch; end; quit'
  d=`expr $d + 1`  

done

