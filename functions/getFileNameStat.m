function currentFileName = getFileNameStat(folder,nodeID,...
                                                            stringIn)
        nodeDataFolder      = folder+ "/"+nodeID;
        currentFileName     = nodeDataFolder+"/"+stringIn + "_" +...
                                    nodeID+ "_results" + ...
                                          ".mat";
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end