function [] = syncFromCloudUTDNodes(nodeIDs,mintsDataFolder)
    folderCheck(mintsDataFolder);
    for nodeIndex = 1: length(nodeIDs) 
        nodeID  = nodeIDs{nodeIndex}.nodeID;
        folderCheck(strcat(mintsDataFolder,"/raw/",nodeID,"/"));
        system(strcat('rsync -avzrtu --exclude={"*.png","*.jpg"} -e "ssh -p 2222" mints@mintsdata.utdallas.edu:raw/',...
                nodeID,"/ ",mintsDataFolder,"/raw/",nodeID,"/"));

    end
    
end



