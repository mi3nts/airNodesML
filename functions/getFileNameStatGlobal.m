function currentFileName = getFileNameStatGlobal(folder,...
                                                            stringIn)
        
        currentFileName     = folder+"/"+stringIn + "_" +...
                                    "results" + ...
                                          ".mat";
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end