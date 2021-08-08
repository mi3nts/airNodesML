function modelFile =  getModelName(maxRow,modelsFolder,mintsTarget)
if sum(ismember(maxRow.Properties.VariableNames,'versionStr'))==0
    maxRow.versionStr = maxRow.versionStrMdl;
end 
    modelFile =  modelsFolder+  string(maxRow.nodeID)+ "/" + string(maxRow.versionStr) ...
                          +"/" +string(maxRow.versionStr)+"_" + string(maxRow.nodeID) +"_"+    mintsTarget +".mat";
                      
                      
end