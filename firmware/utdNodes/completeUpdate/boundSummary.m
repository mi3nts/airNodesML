function  [] = boundSummary(modelsFolder,fileName,nodeIDs,percentage)

    globalCSV   = modelsFolder +"/"+ ...
        fileName+ ".csv";
    
    boundData = readBoundsCSV(globalCSV);
    finalTable = table;
    for nodeIndex = 1:length(nodeIDs)
        nodeID = nodeIDs(nodeIndex);
        currentNodeBounds = boundData(boundData.nodeID == nodeIDs{nodeIndex}.nodeID,:);
        finalTable(nodeIndex,:) = currentNodeBounds(end,:);
    end 
    finalTable.validity =  sum(table2array(finalTable(:,3:end))'>percentage)'  ;
    
    globalCSV   = modelsFolder +"/"+ "boundsSummary.csv"; 
    writetable(finalTable,globalCSV);

end 



