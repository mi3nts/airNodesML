function modelFile =  getModelName(maxRow,modelsFolder,mintsTarget)

    modelFile =  modelsFolder+  string(maxRow.nodeID)+ "/" + string(maxRow.versionStrMdl) ...
                          +"/" +string(maxRow.versionStrMdl)+"_" + string(maxRow.nodeID) +"_"+    mintsTarget +".mat";
                      
                      
end