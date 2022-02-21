function [] = syncFromCloudLoRaNodes(nodeIDs,mintsDataFolder)
    folderCheck(mintsDataFolder);
    for nodeIndex = 1: length(nodeIDs) 
        nodeID  = nodeIDs{nodeIndex}.nodeID;
        folderCheck(strcat(mintsDataFolder,"/rawMqtt/",nodeID,"/"));
        system(strcat('rsync -avzrtu --exclude={"*.png","*.jpg"} -e "ssh -p 2222" mints@mintsdata.utdallas.edu:/mfs/io/groups/lary/mintsData/rawMqtt/',...
                nodeID,"/ ",mintsDataFolder,"/raw/",nodeID,"/"));

    end
    
end

