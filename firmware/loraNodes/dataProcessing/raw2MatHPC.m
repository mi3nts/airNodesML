function [] = row2MatHPC(nodeIndex)

% # ***************************************************************************
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   &
% #   TRECIS: Texas Research and Education Cyberinfrastructure Services
% #   ---------------------------------
% #   Date: June 19th, 2021
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   ---------------------------------------------------------------------
% #   https://github.com/mi3nts
% #   http://utdmints.info/
% #   https://trecis.cyberinfrastructure.org/
% #   http://mintswiki.trecis.cloud/
% #
% #   Contact:
% #      email: lhw150030@utdallas.edu
% # ***********************************************************************
% #   Raw to Mat - Concantinates all .csv files from UTD nodes and creates
% #   a single .mat file for each UTD Node

display(newline)
display("---------------------MINTS---------------------")

addpath("../../../YAMLMatlab_0.4.3")
addpath("../../../functions/")
mintsDefinitions  = ReadYaml('../mintsDefinitionsV2.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/raw";
rawMatsFolder  =  dataFolder + "/rawMats";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)
display(newline)

%syncFromCloudUTDNodes(nodeIDs,dataFolder)

nodeID         = nodeIDs{nodeIndex}.nodeID;

%% Syncing Process
APDS9002   =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'APDS9002',timeSpan);
AS7262     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'AS7262',timeSpan);
BME280     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'BME280',timeSpan);
GL001      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'GL001',timeSpan);
GPSGPGGA2  =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'GPSGPGGA2',timeSpan);
GUV001     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'GUV001',timeSpan);
HM3301     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'HM3301',timeSpan);
LIBRAD     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'LIBRAD',timeSpan);
MGS001     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'MGS001',timeSpan);
OPCN2      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'OPCN2',timeSpan);
OPCN3      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'OPCN3',timeSpan);
PPD42NSDuo =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'PPD42NSDuo',timeSpan);
SCD30      =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SCD30',timeSpan);
SI114X     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SI114X',timeSpan);
SKYCAM2    =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'SKYCAM_002',timeSpan);
TB108L     =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'TB108L',timeSpan);
TMG3993    =  getSyncedDataV2(dataFolder,'/*/*/*/*/*/MINTS_',nodeID,'TMG3993',timeSpan);
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
    saveName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'_30Sec.mat');
    folderCheck(saveName);
    save(saveName,'mintsDataUTD');
else
    display(strcat("No Data for UTD Nodes  Node: ", nodeID ))
end

end
