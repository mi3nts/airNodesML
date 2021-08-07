#!/bin/bash

nodeIndex=1
while [ "$nodeIndex" != 32 ]; do 

  echo  nodeIndex $nodeIndex
  echo  "------------"
 ./testShell.sh $nodeIndex
  nodeIndex=`expr $nodeIndex + 1`  

done

