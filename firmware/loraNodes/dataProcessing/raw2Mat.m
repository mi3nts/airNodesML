
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




% 
% nodeIDs:
%  - nodeID: 47db558000350039
%    sensorStack: 1 
%  - nodeID: 475a5fe30021002d
%    sensorStack: 3
%  - nodeID: 472b544e0018003c
%    sensorStack: 4
%  - nodeID: 47db558000400039
%    sensorStack: 4
%  - nodeID: 472b544e001b003c
%    sensorStack: 1
%  - nodeID: 475a5fe30024001c
%    sensorStack: 4
%  - nodeID: 47db558000410047
%    sensorStack: 4
%  - nodeID: 475a5fe300340018
%    sensorStack: 4
%  - nodeID: 47eb5580003c001a
%    sensorStack: 4
%  - nodeID: 475a5fe3003e0023
%    sensorStack: 4
%  - nodeID: 472b544e00230033
%    sensorStack: 4
%  - nodeID: 472b544e00240036
%    sensorStack: 1
%  - nodeID: 475a5fe3003b001b
%    sensorStack: 2
%  - nodeID: 47cb5580003a001c
%    sensorStack: 2
%  - nodeID: 475a5fe300440023
%    sensorStack: 3
%  - nodeID: 47db558000240039
%    sensorStack: 4
%  - nodeID: 475a5fe3003c0023
%    sensorStack: 4
%  - nodeID: 472b544e0024002b
%    sensorStack: 4
%  - nodeID: 47db558000330044
%    sensorStack: 4
%  - nodeID: 47db5580001e0039
%    sensorStack: 4
%  - nodeID: 8cf95720000589b5
%    sensorStack: 4
%  - nodeID: 472b544e002d004b
%    sensorStack: 1
%  - nodeID: 475a5fe30033001a
%    sensorStack: 2
%  - nodeID: 476a5fe30022002b
%    sensorStack: 2
%  - nodeID: 475a5fe300480023
%    sensorStack: 4
%  - nodeID: 472b544e00250042
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 47eb5580002f0019
%    sensorStack: 4
%  - nodeID: 475a5fe30035001b
%    sensorStack: 4
%  - nodeID: 47db5580002f0042
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 475a5fe3002e001f
%    sensorStack: 1
%  - nodeID: 47db5fe300200033
%    sensorStack: 2
%  - nodeID: 472b544e0024004b
%    sensorStack: 2
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 47db5580002b0039
%    sensorStack: 3
%  - nodeID: 471b41f200340049
%    sensorStack: 4
%  - nodeID: 475a5fe300400022
%    sensorStack: 4
%  - nodeID: 478b5fe30040004b
%    sensorStack: 1
%  - nodeID: 477b41f2004c0035
%    sensorStack: 4
%  - nodeID: 477b41f20048001f
%    sensorStack: 1
%  - nodeID: 478b5fe3002c0019
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 475a5fe30035001a
%    sensorStack: 4
%  - nodeID: 477b41f20049002f
%    sensorStack: 3
%  - nodeID: 47bb5580002d0049
%    sensorStack: 4
%  - nodeID: 47fb558000450044
%    sensorStack: 4
%  - nodeID: 47fb5fe30039004a
%    sensorStack: 1
%  - nodeID: 475a5fe3002a001a
%    sensorStack: 2
%  - nodeID: 47db558000390039
%    sensorStack: 4
%  - nodeID: 475a5fe300200021
%    sensorStack: 4
%  - nodeID: 47cb55800041001c
%    sensorStack: 4
%  - nodeID: 472b544e0028002b
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 47db558000340048
%    sensorStack: 3
%  - nodeID: 475a5fe30031001f
%    sensorStack: 4
%  - nodeID: 475a5fe300320019
%    sensorStack: 4
%  - nodeID: 479b5580001a0031
%    sensorStack: 4
%  - nodeID: 47db558000350047
%    sensorStack: 4
%  - nodeID: 479b558000320033
%    sensorStack: 1
%  - nodeID: 476a5fe300330021
%    sensorStack: 4
%  - nodeID: 476a5fe3003f0021
%    sensorStack: 4
%  - nodeID: 47bb5580001f0020
%    sensorStack: 4
%  - nodeID: 476a5fe300420032
%    sensorStack: 4
%  - nodeID: 475a5fe30038001a
%    sensorStack: 4
%  - nodeID: a000000000000000
%    sensorStack: 4
%  - nodeID: 475a5fe3003b0022
%    sensorStack: 4
%  - nodeID: 47cb558000220031
%    sensorStack: 4
%  - nodeID: 476a5fe300410020
%    sensorStack: 4
%  - nodeID: 8cf9572000059fd7
%    sensorStack: 4
%  - nodeID: 8cf9572000058543
%    sensorStack: 4
%  - nodeID: 475a5fe300300019
%    sensorStack: 4
%  - nodeID: 472b544e00450034
%    sensorStack: 4
%  - nodeID: 478b558000330027
%    sensorStack: 4
%  - nodeID: 479b558000380033
%    sensorStack: 4
%  - nodeID: 470a55800048003e
%    sensorStack: 4
%  - nodeID: 475a5fe3002e0018
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: a0000000000
%    sensorStack: 4
%  - nodeID: 8cf9572000059e7e
%    sensorStack: 4
%  - nodeID: 471a55800038004e
%    sensorStack: 4
%  - nodeID: 475a5fe3002c0020
%    sensorStack: 4
%  - nodeID: 475a5fe3002e0036
%    sensorStack: 4