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
mintsDefinitions  = ReadYaml('mintsDefinitionsV2.yaml')

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
  minLayers= mintsDefinitions.minLayers;
  maxLayers= mintsDefinitions.maxLayers;
  MaxEvaluations= mintsDefinitions.MaxEvaluations;

targets      = mintsDefinitions.targets;
targetLabels = mintsDefinitions.targetLabels;
units        = mintsDefinitions.units;
limitsLow    = mintsDefinitions.limitsLow;
limitsHigh   = mintsDefinitions.limitsHigh;
instruments   = mintsDefinitions.instruments;

climateTargets      = mintsDefinitions.climateTargets;
climateTargetLabels = mintsDefinitions.climateTargetLabels;
climateUnits        = mintsDefinitions.climateUnits;
climateInstrument   = mintsDefinitions.climateInstrument;
climateLimitsLow    = mintsDefinitions.climateLimitsLow;
climateLimitsHigh   = mintsDefinitions.climateLimitsHigh;

% pmTargets           = mintsDefinitions.pmTargets;
% pmTargetLabels      = mintsDefinitions.pmTargetLabels;
% pmUnits             = mintsDefinitions.pmUnits;
%
% pmLimitsLow         = mintsDefinitions.pmLimitsLow;
% pmLimitsHigh        = mintsDefinitions.pmLimitsHigh;


% mintsTargetLabels = mintsDefinitions.mintsTargetLabels;

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



%% Loading Files
display("Loading Palas Files")
load(strcat(palasMatsFolder,"/palas_30Sec.mat"));
palasData = palas;

display("Loading GPS Files");
load(strcat(GPSFolder,"/carGPSCoords_30Sec.mat"));
carGpsData = mintsData;

display("Loading Airmar Files");
load(strcat(airmarFolder,"/airMar_30Sec.mat"));
airmarWSTCPre = airMarSummary(mintsData);

% Convertion to Mili Bar Log
display(" MBL")
airmarWSTC =  correctionsAMV2(airmarWSTCPre);

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
fileName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'_30Sec.mat');

if isfile(fileName)
    load(fileName);
else
    display(strcat("No Data Exists for Node: ",nodeID));
    return
end

%% CN Node Patches 
mintsDataUTD = nodeFixes(nodeID,mintsDataUTD,timeSpan,rawMatsFolder);

%% Defining how may stacks to use
% climate stack and PM stack
eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputsCalib   = mintsDefinitions.climateInputsCalib_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"));

eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmAppendsCalib       = mintsDefinitions.pmAppendsCalib_",string(nodeIDs{nodeIndex}.pmStack),";"));

eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));


%% Cropping GPS Coordinates
utdMints = gpsCropUTD(mintsDataUTD,32.992179, -96.757777,0.0015,0.0015);

% if nodeIndex==20
%     utdMints(utdMints.dateTime<datetime(2020,10,21,'timeZone','utc'),:) = [] ;
% end

%% Data Calibration
% Gaining Only input Variables for training
% utdMints  = correctionsUTDV2(utdMintsPre);

trainingClimate = correctionsUTDV2(utdMints(:,climateInputs));

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

%% Applying Bounds For Climate Data 
climateWithTargets = checkBounds(climateWithTargets,nodeID,versionStr,modelsMatsFolder,"climateBounds");



% This could depend on the implimentation
trainingPM    = correctionsUTDV2(utdMints(:,pmInputs));

% if enough data was recorded
if (height(trainingPM)<100)
    display(strcat("Not enough PM Data points for Node: ",nodeID));
    return
end

pmWithTargets = rmmissing(synchronize(trainingPM,palasWSTC,'intersection'));

display("Saving merged data for PM calibration: "+nodeID )
fileNameStr = strcat(mergedMatsFolder,"/UTDNodes/utdWithPMTargets_", nodeID,".mat");

folderCheck(fileNameStr)
save(fileNameStr,...
    'pmWithTargets');


combined = rmmissing(synchronize(climateWithTargets,pmWithTargets,'intersection'));

display("Saving merged data for PM calibration: "+nodeID )
fileNameStr = strcat(mergedMatsFolder,"/UTDNodes/utdWithAllTargets_", nodeID,".mat");

folderCheck(fileNameStr)
save(fileNameStr,...
    'combined');

%% Creating Training Data for calibration
display(newline)
display("Creating Climate Training Data Sets for Node: "+ nodeID );

%  Climate Targets
climateParams = struct;

climateParams.maxTemperatureK = max(combined.BME280_temperatureK);
climateParams.minTemperatureK = min(combined.BME280_temperatureK);
climateParams.maxHumidity     = max(combined.BME280_humidity);
climateParams.minHumidity     = min(combined.BME280_humidity);
climateParams.maxPressureLog  = max(combined.BME280_pressureLog);
climateParams.minPressureLog  = min(combined.BME280_pressureLog);

% Temperature Calibration
temperatureParams =  calibrateTargetUTDV2(...
    true,climateParams,...
    targets,1,targetLabels,...
    nodeID,"BME280_temperatureK","Temperature",pValid,...
    climateWithTargets,...
    binsPerColumn,numberPerBin,...
    instruments,units,...
    limitsLow,limitsHigh,...
    plotsFolder,dailyString,versionStr,...
    graphTitle1,modelsMatsFolder,...
    globalCSVLabel,trainingMatsFolder,...
            minLayers,maxLayers,MaxEvaluations);

pressureParams =  calibrateTargetUTDV2(...
    true,climateParams,...
    targets,2,targetLabels,...
    nodeID,"BME280_pressureLog","Pressure",pValid,...
    climateWithTargets,...
    binsPerColumn,numberPerBin,...
    instruments,units,...
    limitsLow,limitsHigh,...
    plotsFolder,dailyString,versionStr,...
    graphTitle1,modelsMatsFolder,...
    globalCSVLabel,trainingMatsFolder,...
            minLayers,maxLayers,MaxEvaluations);
humidityParams =  calibrateTargetUTDV2(...
    true,climateParams,...
    targets,3,targetLabels,...
    nodeID,"BME280_humidity","Humidity",pValid,...
    climateWithTargets,...
    binsPerColumn,numberPerBin,...
    instruments,units,...
    limitsLow,limitsHigh,...
    plotsFolder,dailyString,versionStr,...
    graphTitle1,modelsMatsFolder,...
    globalCSVLabel,trainingMatsFolder,...
            minLayers,maxLayers,MaxEvaluations);


%% Add in to the climate params
climateParams.paramsTemperatureK = temperatureParams;
climateParams.paramsPressureLog  = pressureParams;
climateParams.paramsHumidity     = humidityParams;

%% Add the PM Params
climateWithTargets.temperatureCalib = polyval(temperatureParams,...
climateWithTargets.BME280_temperatureK) ;
climateWithTargets.pressureCalib    = polyval(pressureParams,climateWithTargets.BME280_pressureLog) ;
climateWithTargets.humidityCalib    = polyval(temperatureParams,climateWithTargets.BME280_humidity) ;

params =  calibrateTargetUTDV2(...
    false,climateParams,...
    targets,4,targetLabels,...
    nodeID,climateInputsCalib,"Dew Point",pValid,...
    climateWithTargets,...
    binsPerColumn,numberPerBin,...
    instruments,units,...
    limitsLow,limitsHigh,...
    plotsFolder,dailyString,versionStr,...
    graphTitle1,modelsMatsFolder,...
    globalCSVLabel,trainingMatsFolder,...
    minLayers,maxLayers,MaxEvaluations);

% Here We need to decide which parametors are used, either real climate
% values or calib climate values
% pmWithTargetsAppended = rmmissing(synchronize(pmWithTargets,palasWSTC,'intersection'));
pmInputsCombined       = [pmInputsCorrected,pmAppendsCalib];



pmInputsLabelsCombined = [pmInputLabels,climateInputLabels];

trainingPMCombined    = correctionsUTDV2(utdMints(:,[climateInputs,pmInputs]));


trainingPMCombined = checkBounds(trainingPMCombined,nodeID,versionStr,modelsMatsFolder,"pmBounds");

%% Apply Bounds 

pmWithTargetsCombined = rmmissing(synchronize(trainingPMCombined,palasWSTC,'intersection'));
pmWithTargetsCombined.temperatureCalib = polyval(temperatureParams,pmWithTargetsCombined.BME280_temperatureK) ;
pmWithTargetsCombined.pressureCalib    = polyval(pressureParams   ,pmWithTargetsCombined.BME280_pressureLog) ;
pmWithTargetsCombined.humidityCalib    = polyval(temperatureParams,pmWithTargetsCombined.BME280_humidity) ;


% Use Optimized Fit R Net
%% Calibration for PM Targets
for targetIndex = 5: length(targets)
%     try
        %% Optimal Input Calculation
     calibrateTargetUTDV2(...
        false,climateParams,...
        targets,targetIndex,targetLabels,...
        nodeID,pmInputsCombined ,pmInputsLabelsCombined,pValid,...
        pmWithTargetsCombined,...
        binsPerColumn,numberPerBin,...
        instruments,units,...
        limitsLow,limitsHigh,...
        plotsFolder,dailyString,versionStr,...
        graphTitle1,modelsMatsFolder,...
        globalCSVLabel,trainingMatsFolder,...
            minLayers,maxLayers,MaxEvaluations);

%     catch e
%         close all
%         fprintf(1,'The identifier was:\n%s',e.identifier);
%         fprintf(1,'There was an error! The message was:\n%s',e.message);
%     end
end

end
%% End of code
