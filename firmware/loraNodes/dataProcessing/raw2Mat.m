
% # ***************************************************************************
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   & 
% #   TRECIS: Texas Research and Education Cyberinfrastructure Services  
% #   ---------------------------------
% #   Date: Nov 21st, 2021
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   ---------------------------------------------------------------------
% #   
% #   MINTS:
% #      https://github.com/mi3nts
% #      http://utdmints.info/
% #   TRECIS
% #      https://trecis.cyberinfrastructure.org/
% #      http://mintswiki.trecis.cloud/
% #   
% #   Contact: 
% #      email: lhw150030@utdallas.edu 
% # ***********************************************************************
% #   Raw to Mat - Concantinates all .csv files from UTD nodes and creates 
% #   a single .mat file for each UTD Node    

clc
clear all
close all

display(newline)
display("---------------------MINTS---------------------")

addpath("../../../YAMLMatlab_0.4.3")
addpath("../../../functions/")
mintsDefinitions  = ReadYaml('../mintsDefinitionsLR.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/rawMqtt";
rawMatsFolder  =  dataFolder + "/rawMats";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)
display(newline)

for nodeIndex = 1: length(nodeIDs)
    
    nodeID         = nodeIDs{nodeIndex}.nodeID
        
    %% Syncing Process     
    BME280     =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'BME280',timeSpan);
    IPS7100    =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'IPS7100',timeSpan);
    PM         =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'PM',timeSpan);
    SCD30      =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SCD30',timeSpan);
    MGS001     =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'MGS001',timeSpan);
    INA219Duo  =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'INA219Duo',timeSpan);
    GPGGALR  =  getSyncedDataLR(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'GPGGALR',timeSpan);
    %% Choosing Input Stack
    wholeStack = mintsDefinitions.wholeStack;
    
    display("Saving UTD Nodes Data");
    
    concatStr  =  "mintsDataLR   = synchronize(";
    for stackIndex = 1: length(wholeStack)
        if(height(eval(strcat(wholeStack{stackIndex})))>2)
            concatStr = strcat(concatStr,wholeStack{stackIndex},",");
        end
    end
    try
        concatStr  = strcat(concatStr,"'union');");
        display(concatStr)
        eval(concatStr)
        if(height(mintsDataLR) >0)
            display(strcat("Saving LoRa Node Data for : ", nodeID));
            saveName  = strcat(rawMatsFolder,'/LoRaNodes/Mints_LoRa_Node_',nodeID,'_',string(timeSpan),'.mat');
            folderCheck(saveName);
            save(saveName,'mintsDataLR');
        else
            display(strcat("No Data for LoRa Nodes  Node: ", nodeID ))
        end
        
    catch e
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
    
    clearvars -except dataFolder rawMatsFolder ...
        nodeIDs timeSpan ...
        nodeIndex mintsDefinitions
end




