function [daysBackEnd,daysBackStart] = getSummary(nodeIndex)

    addpath("../../../functions/")

    addpath("../../../YAMLMatlab_0.4.3")

    yamlFile =  '../mintsDefinitionsV2.yaml';
    
    mintsDefinitions   = ReadYaml(yamlFile);

    nodeIDs            = mintsDefinitions.nodeIDs;
    dataFolder         = mintsDefinitions.dataFolder;
    
    timeSpan           =  seconds(mintsDefinitions.timeSpan);
    nodeID             =  nodeIDs{nodeIndex}.nodeID;
    
    rawFolder          =  dataFolder + "/raw";
    rawMatsFolder      =  dataFolder + "/rawMats";
    loadName = strcat(rawMatsFolder,"/UTDNodes/Mints_UTD_Node_",nodeID,"_30Sec.mat");
    load(loadName)
    
    sumCSV = strcat(rawMatsFolder,"/UTDNodes/summary/Mints_UTD_Node_Summary_",nodeID,".csv");
    

    eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
    eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));

    mintsDataUTD = rmmissing(mintsDataUTD(:,[pmInputs,climateInputs]));
    
    startDate = mintsDataUTD.dateTime(1);
    endDate   = mintsDataUTD.dateTime(end);

    daysBackStart =  abs(ceil(daysact(datetime('today','timezone','utc'), startDate)))
    daysBackEnd   = abs(floor(daysact(datetime('today','timezone','utc'), endDate)))
    if(daysBackEnd)<1
     daysBackEnd =1;   
    end
       

    tempCSV.startDate     = startDate;
    tempCSV.endDate       = endDate  ;
    tempCSV.nodeID        = nodeID;
    tempCSV.daysBackEnd   = daysBackEnd  ;
    tempCSV.daysBackStart = daysBackStart;
    folderCheck(sumCSV);
    writetable(struct2table(tempCSV), sumCSV);
    summary = "summary/summary_"+nodeIndex+".log"
    folderCheck(summary);
    writetable(struct2table(tempCSV), summary,'FileType',  'text','WriteVariableNames',0);
    
    
end
    
     