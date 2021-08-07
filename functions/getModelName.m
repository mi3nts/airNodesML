function modelFile =  getModelName(maxRow,modelsFolder,mintsTarget)

    modelFile =  modelsFolder+  string(maxRow.nodeID)+ "/" + string(maxRow.versionStr) ...
                          +"/" +string(maxRow.versionStr)+"_" + string(maxRow.nodeID) +"_"+    mintsTarget +".mat";
                      
                      
end