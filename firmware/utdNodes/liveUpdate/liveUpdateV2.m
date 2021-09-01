function [] = liveUpdateV2(nodeIndex)

display(newline);
display("---------------------MINTS---------------------");

currentDate= datetime('now','timezone','utc');

display(currentDate);
yamlFile =  '../mintsDefinitionsV2.yaml';

mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;


climateTargets     = mintsDefinitions.climateTargets;
pmTargets          = mintsDefinitions.pmTargets;
allTargets         = [climateTargets,pmTargets];


rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/results/";
scanFolder         =  dataFolder + "/liveUpdate/scan/";
modelsFolder       =  dataFolder + "/modelsMats/UTDNodes/";

timeSpan           =  seconds(mintsDefinitions.timeSpan);
nodeID             =  nodeIDs{nodeIndex}.nodeID;
resultsFile        = modelsFolder+ "WSInitialV2.csv";

targets           = mintsDefinitions.targets;
timeFile          =  strcat(scanFolder,"t_"+nodeID,".mat");
folderCheck(timeFile) ;
display(timeFile);

todaysNodeFolder   = strcat("/*/*/",...
    num2str(year(currentDate),'%04d'),"/",...
    num2str(month(currentDate),'%02d'),"/",...
    num2str(day(currentDate),'%02d'),"/MINTS_")    ;

display(newline);
display("Data Folder Located      @ :"+ dataFolder);
display("Raw Data Located         @ :"+ rawFolder );
display("Raw DotMat Data Located  @ :"+ rawMatsFolder);
display("Update Data Located      @ :"+ updateFolder);
display("Results File Located     @ :"+ resultsFile);
display(newline)

%% Syncing Process
BME280     =  getSyncedDataV2(dataFolder,todaysNodeFolder ,nodeID,'BME280',timeSpan);
GPSGPGGA2  =  getSyncedDataV2(dataFolder,todaysNodeFolder ,nodeID,'GPSGPGGA2',timeSpan);
OPCN2      =  getSyncedDataV2(dataFolder,todaysNodeFolder ,nodeID,'OPCN2',timeSpan);
OPCN3      =  getSyncedDataV2(dataFolder,todaysNodeFolder ,nodeID,'OPCN3',timeSpan);

if isempty(BME280)||(isempty(OPCN2)&&isempty(OPCN3))
    display("No Data for Node:" +  nodeID);
    return;
end


%% Choosing Input Stack
liveStack = mintsDefinitions.liveStack;

display("Getting Node Data for Today");

concatStr  =  "mintsDataUTD   = synchronize(";
for stackIndex = 1: length(liveStack)
    if(height(eval(strcat(liveStack{stackIndex})))>2)
        concatStr = strcat(concatStr,liveStack{stackIndex},",");
    end
end
concatStr  = strcat(concatStr,"'union');");
% display(concatStr);
eval(concatStr);

%% Checking for availability 
printName=getPrintName(updateFolder,nodeID,currentDate,'calibrated');
csvAvailable =     isfile(printName);


if height(mintsDataUTD)<4
   display("Not enough data for today on node:" +  nodeID);
   return;
end   

if csvAvailable
    currentTime  =  load(timeFile).nextTime;
    mintsDataUTD =  mintsDataUTD(mintsDataUTD.dateTime>currentTime,:);
else
    currentTime = datetime(2016,1,1,'timezone','utc');
end

if height(mintsDataUTD) <= 0
   display("no new data for node:" +  nodeID);
   return;
end   


nextTime = mintsDataUTD.dateTime(end);
mintsDataUTD(end-3:end,:) =[];


%% Choosing Input Stack
eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputsCalib   = mintsDefinitions.climateInputsCalib_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"));

eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmAppendsCalib       = mintsDefinitions.pmAppendsCalib_",string(nodeIDs{nodeIndex}.pmStack),";"));

eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("csvStack             = mintsDefinitions.csvStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

%% Defining Inputs
inCorrected  = correctionsUTDV2(mintsDataUTD);

% At this point I can load in the best model file
display("Loading Best Models");
[bestModels,bestModelsLabels,climateParamsNow] = readResultsNowV2(resultsFile,nodeID,targets,modelsFolder);

display("Climate Bounding");

% Probably and if Statement Goes here
inCorrected = checkBounds(inCorrected,nodeID,"LiveUpdate",modelsFolder,"liveUpdate");

if height(inCorrected)<2
    display("Sensor Error For:" +  nodeID);
    return;
end

inCorrected = boundCorrections(inCorrected,climateParamsNow);


%% Loading the appropriate models
% At this point new the best models are loaded

inCorrected.temperatureCalib = polyval(bestModels{1},...
    inCorrected.BME280_temperatureK) ;
inCorrected.pressureCalib    = polyval(bestModels{2},...
    inCorrected.BME280_pressureLog) ;
inCorrected.humidityCalib    = polyval(bestModels{3},...
    inCorrected.BME280_humidity) ;

pmInputsCombined             = [pmInputsCorrected,pmAppendsCalib];

[rows, columns] = find(isnan(table2array(inCorrected(:,pmInputsCombined))));

inCorrected(unique(rows),:) = [];



%% Dew Point Results
inDewPoint = table2array(inCorrected(:,climateInputsCalib));
inCorrected.dewPoint_predicted=predict(bestModels{4},inDewPoint);
inPM       = table2array(inCorrected(:,pmInputsCombined));

% Pm Models are coming after 5 
for n = 5: length(bestModels)
    display("Predicting " + targets{n});
    eval(strcat("inCorrected.",targets{n},"_predicted= " , "predict(bestModels{n},inPM);"));
end



%% Applying Corrections
inCorrected =  correctionsPM(inCorrected);

inCorrected.temperatureOut = inCorrected.temperatureCalib;
inCorrected.pressureOut    = 10.^(inCorrected.pressureCalib);
inCorrected.humidityOut    = inCorrected.humidityCalib;
inCorrected.dewPointOut    = inCorrected.dewPoint_predicted;


if isempty(GPSGPGGA2)
    inCorrected.GPSGPGGA2_latitudeCoordinate(:) = nan;
    inCorrected.GPSGPGGA2_longitudeCoordinate(:) = nan;
    inCorrected.GPSGPGGA2_altitude(:) = nan;
end

inCorrected.GPSGPGGA2_altitude(isnan(inCorrected.GPSGPGGA2_altitude))=...
                                        nodeIDs{nodeIndex}.altitude;
inCorrected.GPSGPGGA2_latitudeCoordinate(isnan(inCorrected.GPSGPGGA2_latitudeCoordinate))=...
                                        nodeIDs{nodeIndex}.latitude;
inCorrected.GPSGPGGA2_longitudeCoordinate(isnan(inCorrected.GPSGPGGA2_longitudeCoordinate))=...
                                        nodeIDs{nodeIndex}.longitude;

%% Checks

varNames = inCorrected.Properties.VariableNames;

for n = 1 :length(varNames)
    varNames{n} =   strrep(varNames{n},'OPCN2_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'OPCN3_binCount','Bin');
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

inCorrected.Properties.VariableNames = varNames;
inCorrected.dateTime.Format =  'uuuu-MM-dd HH:mm:ss.SSS';

predictedFinal =  inCorrected(:,csvStack);

printName=getPrintName(updateFolder,nodeID,currentDate,'calibrated');



if csvAvailable
   writetimetable(predictedFinal,printName,'WriteMode','append','WriteVariableNames',false);
else
    printCSVT(bestModelsLabels,updateFolder,nodeID,currentDate,'modelInfoLive');
    writetimetable(predictedFinal,  printName);
end

save(timeFile,'nextTime');
display("MINTS Done")

end

