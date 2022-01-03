#!/bin/bash

nodeIndex=1
while [ "$nodeIndex" != 32 ]; do 

  echo  nodeIndex $nodeIndex
  echo  "------------"
 ./dailyUpdateShell.sh $nodeIndex
  nodeIndex=`expr $nodeIndex + 1`  

done

