
function [] = utdNodesV2(nodeIndex)
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
% #  UTD Nodes ONN - Conducts Machine Learning Calibration to Calibrate
% #  UTD  Nodes - Using an Optimized Neural Net
% #
clc
clearvars -except nodeIndex
close all

versionStrPre = 'UTD_V2_';
versionStr = [versionStrPre datestr(now,'yyyy_mm_dd_HH_MM_SS')];
disp(versionStr)
display(newline)
dailyString        =versionStrPre+"Daily";
disp(dailyString)
display(newline)
graphTitle1     = "Optimzed NN";
disp(graphTitle1)
display(newline)
globalCSVLabel = "WSInitialV2"

% poolobj = gcp('nocreate');
% delete(poolobj);

display(newline)
display("---------------------MINTS---------------------")
display(datestr(datetime('now')))
addpath("../../../functions/")

addpath("../../../YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('mintsDefinitions2021.yaml')

dataFolder          = mintsDefinitions.dataFolder;
nodeIDs             = mintsDefinitions.nodeIDs;
timeSpan            = seconds(mintsDefinitions.timeSpan);
binsPerColumn       = mintsDefinitions.binsPerColumn;
numberPerBin        = mintsDefinitions.numberPerBin ;
pValid              = mintsDefinitions.pValid;
airmarID            = mintsDefinitions.airmarID;
instruments         = mintsDefinitions.instruments;
units               = mintsDefinitions.units;
poolWorkers         = mintsDefinitions.poolWorkers;

climateTargets      = mintsDefinitions.climateTargets;
climateTargetLabels = mintsDefinitions.climateTargetLabels;
climateUnits        = mintsDefinitions.climateUnits;
climateInstrument   = mintsDefinitions.climateInstrument;
climateLimitsLow    = mintsDefinitions.climateLimitsLow;
climateLimitsHigh   = mintsDefinitions.climateLimitsHigh;

pmTargets           = mintsDefinitions.pmTargets;
pmTargetLabels      = mintsDefinitions.pmTargetLabels;
pmUnits             = mintsDefinitions.pmUnits;
pmInstrument        = mintsDefinitions.pmInstrument;
pmLimitsLow         = mintsDefinitions.pmLimitsLow;
pmLimitsHigh        = mintsDefinitions.pmLimitsHigh;


mintsTargetLabels = mintsDefinitions.mintsTargetLabels;

rawFolder           =  dataFolder + "/raw";
rawMatsFolder       =  dataFolder + "/rawMats";
minMaxFolder        =  dataFolder + "/minMax";
UTDMatsFolder       =  rawMatsFolder  + "/UTDNodes";
referenceFolder     =  dataFolder + "/reference";
referenceMatsFolder =  dataFolder + "/referenceMats";
palasFolder         =  referenceFolder       + "/palasStream";
palasMatsFolder     =  referenceMatsFolder   + "/palas";
driveSyncFolder     =  strcat(dataFolder,"/exactBackUps/palasStream/");
mergedMatsFolder    =  dataFolder + "/mergedMats/UTDNodes";
GPSFolder           =  referenceMatsFolder + "/carGPS"  ;
airmarFolder        =  referenceMatsFolder + "/airmar"
modelsMatsFolder    =  dataFolder + "/modelsMats/UTDNodes";
trainingMatsFolder  =  dataFolder + "/trainingMats/UTDNodes";
plotsFolder         =  dataFolder + "/visualAnalysis/UTDNodes";
resultsFolder       =  dataFolder + "/results/UTDNodes";
updateFolder       =  dataFolder + "/lastUpdate/UTDNodes";

display(newline)
folderCheck(dataFolder)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)
display("UTD Nodes DotMat Data Located @ :"+ UTDMatsFolder)
display("Reference Data Located @: "+ referenceFolder )
display("Reference DotMat Data Located @ :"+ referenceMatsFolder)
display("Palas Raw Data Located @ :"+ palasFolder)
display("Palas DotMat Data Located @ :"+ palasMatsFolder)
display("Car GPS Files Located @ :"+ GPSFolder)

display("Climate Targets :")
climateTargets
display("PM Targets:" )
pmTargets


%% Loading Files
display("Loading Palas Files")
load(strcat(palasMatsFolder,"/palas_30Sec.mat"));
palasData = palas;

display("Loading GPS Files");
load(strcat(GPSFolder,"/carGPSCoords_30Sec.mat"));
carGpsData = mintsData;

display("Loading Airmar Files");
load(strcat(airmarFolder,"/airMar_30Sec.mat"));
airmarWSTC = airMarSummary(mintsData);

%% Syncing Data
display("Aligning GPS data with Palas Data")
palasWithGPS  =  rmmissing(synchronize(palasData,carGpsData,'intersection'));

display("WSTC Palas Data")
palasWSTC = gpsCropCoord(palasWithGPS,32.992179, -96.757777,0.0015,0.0015);
palasWSTC = removevars( palasWSTC, {...
    'latitudeCoordinate'  ,...
    'longitudeCoordinate'  });

display("Palas With Airmar")

palasWithAirmar  =  rmmissing(synchronize(palasWSTC,airmarWSTC,'intersection'));

%% Loading UTD Data and merging them with Palas Data
display("Analysis")

nodeID = nodeIDs{nodeIndex}.nodeID;

%% Loading the mat file for calibration
fileName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'.mat');
if isfile(fileName)
    load(fileName);
else
    display(strcat("No Data Exists for Node: ",nodeID));
    return
end

%% Defining how may stacks to use
% climate stack and PM stack
eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"))
eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"))

eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))

eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

%% Cropping GPS Coordinates

utdMints = gpsCropUTD(mintsDataUTD,32.992179, -96.757777,0.0015,0.0015);

if nodeIndex==20
    utdMints(utdMints.dateTime<datetime(2020,10,21,'timeZone','utc'),:) = [] ;
end


%% Data Calibration

% Gaining Only input Variables for training
trainingClimate = rmmissing(utdMints(:,climateInputs));

% if enough data was recorded
if (height(trainingClimate)<100)
    display(strcat("Not enough Climate Data points for Node: ",nodeID));
    return
end

climateWithTargets =  rmmissing(synchronize(trainingClimate,airmarWSTC,'intersection'));

display("Saving merged data for climate calibration: "+nodeID )
fileNameStr = strcat(mergedMatsFolder,"/UTDNodes/utdWithClimateTargets_", nodeID,".mat");

folderCheck(fileNameStr)
save(fileNameStr,...
    'climateWithTargets');

%% compliling the data set for pm calibration puts));
trainingPM = rmmissing(utdMints(:,pmInputs))   ;

% if enough data was recorded
if (height(trainingPM)<100)
    display(strcat("Not enough PM Data points for Node: ",nodeID));
    return
end

pmWithTargetsPre = rmmissing(synchronize(trainingPM,palasWSTC,'intersection'));
pmWithTargets = correctionsV2(sensorStack,nodeID,...
    pmWithTargetsPre,minMaxFolder);

% May have to be used
% Keeping the Original Cap
% if (nodeID ~= "001e06318c28")
%    utdWithTargets(utdWithTargets.pm1>500,:) = [];
% end

%% Creating Training Data for calibration
display(newline)
display("Creating Climate Training Data Sets for Node: "+ nodeID );

%  Climate Targets
% for targetIndex = 1: length(climateTargets)
%     %     try
%     calibrateTargetUTD(...
%         climateTargets,targetIndex,climateTargetLabels,...
%         nodeID,climateInputs,climateInputLabels,pValid,...
%         climateWithTargets,...
%         binsPerColumn,numberPerBin,...
%         climateInstrument,climateUnits,...
%         climateLimitsLow,climateLimitsHigh,...
%         plotsFolder,dailyString,versionStr,...
%         graphTitle1,modelsMatsFolder,...
%         globalCSVLabel,trainingMatsFolder);
%     
%     display(newline);
    
    %     catch e
    %         close all
    %         fprintf(1,'The identifier was:\n%s',e.identifier);
    %         fprintf(1,'There was an error! The message was:\n%s',e.message);
    %     end
% end

%% Calibration for PM Targets
%% Climate Targets
for targetIndex = 1: length(pmTargets)
    %     try
    %% Optimal Input Calculation
    calibrateTargetUTD(...
        pmTargets,targetIndex,pmTargetLabels,...
        nodeID,pmInputsCorrected,pmInputLabels,pValid,...
        pmWithTargets,...
        binsPerColumn,numberPerBin,...
        pmInstrument,pmUnits,...
        pmLimitsLow,pmLimitsHigh,...
        plotsFolder,dailyString,versionStr,...
        graphTitle1,modelsMatsFolder,...
        globalCSVLabel,trainingMatsFolder)
    
    display(newline);
    
    %     catch e
    %         close all
    %         fprintf(1,'The identifier was:\n%s',e.identifier);
    %         fprintf(1,'There was an error! The message was:\n%s',e.message);
    %     end
end

end
%% End of code