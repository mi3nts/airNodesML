
clc
clear all
close all
clc
clear all
close all

display(newline)
display("---------------------MINTS---------------------")

addpath("../YAMLMatlab_0.4.3")
addpath("../functions/")
mintsDefinitions  = ReadYaml('mintsDefinitions.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/raw";
rawMatsFolder  =  dataFolder + "/rawMats";
% matsFolder     =  dataFolder + "/mats";


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)

display(newline)

% syncFromCloudUTDNodes(nodeIDs,dataFolder)


for nodeIndex = 1: length(nodeIDs)
    
    nodeID         = nodeIDs{nodeIndex}.nodeID;
    
    %% Syncing Process     
    AS7262     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'AS7262',timeSpan);    
    BME280     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'BME280',timeSpan);
    GPSGPGGA2  =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'GPSGPGGA2',timeSpan);
    LIBRAD     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'LIBRAD',timeSpan);
    MGS001     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'MGS001',timeSpan);
    OPCN2      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'OPCN2',timeSpan);
    OPCN3      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'OPCN3',timeSpan);
    PPD42NSDuo =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'PPD42NSDuo',timeSpan);
    SCD30      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SCD30',timeSpan);
    SKYCAM2    =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SKYCAM_002',timeSpan);
    TSL2591    =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'TSL2591',timeSpan);
    VEML6075   =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'VEML6075',timeSpan);
    
    %% Choosing Input Stack
    wholeStack = mintsDefinitions.wholeStack;
    
    display("Saving UTD Nodes Data");
    
    concatStr  =  "mintsDataUTD   = synchronize(";
    for stackIndex = 1: length(wholeStack)
        if(height(eval(strcat(wholeStack{stackIndex})))>2)
            concatStr = strcat(concatStr,wholeStack{stackIndex},",");
        end
    end
    concatStr  = strcat(concatStr,"'union');");
    display(concatStr)
    eval(concatStr)
    

    if(height(mintsDataUTD) >0)
        display(strcat("Saving UTD Node Data for : ", nodeID));
        saveName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'.mat');
        folderCheck(saveName);
        save(saveName,'mintsDataUTD');
    else
        display(strcat("No Data for UTD Nodes  Node: ", nodeID ))
    end
    
    clearvars -except dataFolder rawMatsFolder ...
        nodeIDs timeSpan ...
        nodeIndex mintsDefinitions
end
