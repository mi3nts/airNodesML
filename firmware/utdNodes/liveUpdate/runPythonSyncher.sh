#!/bin/bash -l
while true
do 
echo SYCHING LIVE DATA FROM MINTDATA_UTDALLAS_EDU 
python3 pythonSyncher.py ../mintsDefinitionsV2.yaml
done 



