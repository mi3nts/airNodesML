function [] = completeUpdateLiveV3Joppa(nodeIndex)
currentDate= datetime('now','timezone','utc');
display(newline)
% display("---------------------MINTS---------------------")

addpath("../../../functions/")
addpath("../../../functions/ZipLatLon")
addpath("../../../YAMLMatlab_0.4.3")

yamlFile =  '../mintsDefinitionsJ.yaml';

mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;

rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/UTDNodes";
modelsFolder       =  dataFolder + "/modelsMats/UTDNodes/";

timeSpan           =  seconds(mintsDefinitions.timeSpan);
nodeID             =  nodeIDs{nodeIndex}.nodeID;
resultsFile        = modelsFolder+ "WSInitialV3.csv";

display(newline);
display("Data Folder Located      @ :"+ dataFolder);
display("Raw Data Located         @ :"+ rawFolder );
display("Raw DotMat Data Located  @ :"+ rawMatsFolder);
display("Update Data Located      @ :"+ updateFolder);
stringIn = "Daily";

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

display("Getting Historic Update for Node: "+ nodeID);
display("Currrent Time is "+ datestr(datetime('now')));
display("---------------------MINTS---------------------")

versionStrPreHistoric = 'UTD_V3_Historic_';
versionStrHistoric = [versionStrPreHistoric datestr(now,'yyyy_mm_dd_HH_MM_SS')];


%% Loading from previiously Saved Data files
loadName = strcat(rawMatsFolder,"/UTDNodes/Mints_UTD_Node_",nodeID,"_30Sec.mat");
load(loadName)

mintsDataUTD = nodeFixes(nodeID,mintsDataUTD,rawMatsFolder);


printName= updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Joppa_Raw.csv";
% display("MINTS Saving: " +printName)
mintsDataUTD = gpsCropUTD(mintsDataUTD,32.7153833,-96.7475846,.0005,.0005);

varNames = mintsDataUTD.Properties.VariableNames;

for n = 1 :length(varNames)
    varNames{n} =   strrep(varNames{n},'OPCN2_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'OPCN3_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'OPCN3_pm','PM');
    varNames{n} =   strrep(varNames{n},'OPCN2_pm','PM');
    
    varNames{n} =   strrep(varNames{n},'BME280_temperature','Temperature');
    varNames{n} =   strrep(varNames{n},'BME280_pressure','Pressure');
    varNames{n} =   strrep(varNames{n},'BME280_humidity','Humidity');
    
    varNames{n} =   strrep(varNames{n},'pm1_palas_predicted','PM1');
    varNames{n} =   strrep(varNames{n},'pm2_5_palas_predicted','PM2_5');
    varNames{n} =   strrep(varNames{n},'pm4_palas_predicted','PM4');
    varNames{n} =   strrep(varNames{n},'pm10_palas_predicted','PM10');
    varNames{n} =   strrep(varNames{n},'temperatureOut','Temperature');
    varNames{n} =   strrep(varNames{n},'pressureOut','Pressure');
    varNames{n} =   strrep(varNames{n},'humidityOut','Humidity');
    varNames{n} =   strrep(varNames{n},'dewPointOut','DewPoint');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_latitudeCoordinate','Latitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_longitudeCoordinate','Longitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_altitude','Altitude');
end

eval(strcat("csvStack             = mintsDefinitions.csvStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

mintsDataUTD.Properties.VariableNames = varNames;
mintsDataUTD.dateTime.Format =  'uuuu-MM-dd HH:mm:ss.SSS';

% inCorrected  = correctionsUTDV2(mintsDataUTD);
if(height(mintsDataUTD)>1)
    display("MINTS Saving: " +printName)
    predictedFinal =  rmmissing(mintsDataUTD(:,csvStack));
    writetimetable(predictedFinal,  printName)
end





% %% Choosing Input Stack
% eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));
% eval(strcat("climateInputsCalib   = mintsDefinitions.climateInputsCalib_",nodeIDs{nodeIndex}.climateStack,";"));
% eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"));
% 
% eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))
% eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmAppendsCalib       = mintsDefinitions.pmAppendsCalib_",string(nodeIDs{nodeIndex}.pmStack),";"));
% 
% eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

% %% Defining Inputs

% % At this point I can load in the best model file
% display("Loading Best Models")
% [bestModels,bestModelsLabels,climateParamsNow] = readResultsNowV2(...
%                         resultsFile,nodeID,targets,modelsFolder);
% 
% display("Climate Bounding")
% 
% % Global Bounds 
% inCorrected = checkBounds(inCorrected,nodeID,versionStrHistoric,modelsFolder,"completeBounds");
% % Training Bounds 
% inCorrected = boundCorrections(inCorrected,climateParamsNow);
% 
% 
% %% Loading the appropriate models
% % At this point new the best models are loaded
% 
% inCorrected.temperatureCalib = polyval(bestModels{1},...
%     inCorrected.BME280_temperatureK) ;
% inCorrected.pressureCalib    = polyval(bestModels{2},...
%     inCorrected.BME280_pressureLog) ;
% inCorrected.humidityCalib    = polyval(bestModels{3},...
%     inCorrected.BME280_humidity) ;
% 
% pmInputsCombined             = [pmInputsCorrected,pmAppendsCalib];
% 
% [rows, columns] = find(isnan(table2array(inCorrected(:,pmInputsCombined))));
% 
% inCorrected(unique(rows),:) = [];
% 
% 
% 
% %% Dew Point Results
% inDewPoint = table2array(inCorrected(:,climateInputsCalib));
% 
% inCorrected.dewPoint_predicted=predict(bestModels{4},inDewPoint);
% 
% inPM       = table2array(inCorrected(:,pmInputsCombined));
% 
% % Pm Models are coming after 5 
% for n = 5: length(bestModels)
%     display("Predicting " + targets{n})
%     eval(strcat("inCorrected.",targets{n},"_predicted= " , "predict(bestModels{n},inPM);"));
% end
% 
% 
% 
% %% Applying Corrections
% inCorrected =  correctionsPM(inCorrected);
% 
% inCorrected.temperatureOut = inCorrected.temperatureCalib;
% inCorrected.pressureOut    = 10.^(inCorrected.pressureCalib);
% inCorrected.humidityOut    = inCorrected.humidityCalib;
% inCorrected.dewPointOut    = inCorrected.dewPoint_predicted;
% 
% 
% varNames = inCorrected.Properties.VariableNames;
% 
% for n = 1 :length(varNames)
%     varNames{n} =   strrep(varNames{n},'OPCN2_binCount','Bin');
%     varNames{n} =   strrep(varNames{n},'OPCN3_binCount','Bin');
%     varNames{n} =   strrep(varNames{n},'pm1_palas_predicted','PM1');
%     varNames{n} =   strrep(varNames{n},'pm2_5_palas_predicted','PM2_5');
%     varNames{n} =   strrep(varNames{n},'pm4_palas_predicted','PM4');
%     varNames{n} =   strrep(varNames{n},'pm10_palas_predicted','PM10');
%     varNames{n} =   strrep(varNames{n},'temperatureOut','Temperature');
%     varNames{n} =   strrep(varNames{n},'pressureOut','Pressure');
%     varNames{n} =   strrep(varNames{n},'humidityOut','Humidity');
%     varNames{n} =   strrep(varNames{n},'dewPointOut','DewPoint');
%     varNames{n} =   strrep(varNames{n},'GPSGPGGA2_latitudeCoordinate','Latitude');
%     varNames{n} =   strrep(varNames{n},'GPSGPGGA2_longitudeCoordinate','Longitude');
%     varNames{n} =   strrep(varNames{n},'GPSGPGGA2_altitude','Altitude');
% end
% 
% inCorrected.Properties.VariableNames = varNames;
% inCorrected.dateTime.Format =  'uuuu-MM-dd HH:mm:ss.SSS';
% predictedFinal =  inCorrected(:,csvStack);
% 
% printName= updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Joppa_Complete.csv";
% % display("MINTS Saving: " +printName)
% predictedFinal2 = gpsCropFinalUTD(rmmissing(predictedFinal),32.7153833,-96.7475846,.0005,.0005);
% 
% if(height(predictedFinal2)>1)
%     display("MINTS Saving: " +printName)
%     writetimetable(predictedFinal2,  printName)
% end

% 
% printCSVHistoric(bestModelsLabels,updateFolder,nodeID,'modelInfo');
% display("MINTS CSVs Done")
% 
% getScatterPlotResults(nodeIndex)
% boundSummary(modelsFolder,"completeBounds",nodeIDs,7.5)

end

%% 5a61 : Aug 2021, Oct 10 - Now
%% 5a12 : Sep - Oct 10 @ Joppa

