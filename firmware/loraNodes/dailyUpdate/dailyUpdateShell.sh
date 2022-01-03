#!/bin/bash
matlab -nodisplay -nosplash -nodesktop -batch 'try getSummary('$1'); catch; end; quit'

INPUT=summary/summary_$1.log
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read startDate endDate nodeID daysBackEnd daysBackStart
do
	echo "startDate : $startDate"
	echo "endDate : $endDate"
	echo "nodeID : $nodeID"
	echo "daysBackEnd : $daysBackEnd"
	echo "daysBackStart : $daysBackStart"

echo "----------------"
echo "daysBackEnd : $daysBackEnd"
echo "daysBackStart : $daysBackStart"
echo "----------------"


#target_date="Jan 1 2019"
#today=`echo $(($(date --utc --date "$1" +%s)/86400))`
#target=`echo $(($(date --utc --date "$target_date" +%s)/86400))`
#days=`expr $today - $target`
#echo "$days days until $target_date"


while [ "$daysBackEnd" != $daysBackStart ]; do 

  echo  nodeIndex $1
  echo  Days Back $daysBackEnd
  echo  "------------"

  matlab -nodisplay -nosplash -nodesktop -batch 'try dailyUpdateLive('$1','$daysBackEnd'); catch; end; quit'
  daysBackEnd=`expr $daysBackEnd + 1`  

done
done < $INPUT
IFS=$OLDIFS

