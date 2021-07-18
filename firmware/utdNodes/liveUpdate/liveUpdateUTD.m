function [] = liveUpdateUTD(nodeIndex,yamlFile)
tic
display(newline)
display("---------------------MINTS---------------------")

%     nodeIndex = round(str2double(nodeIndex)) ;
currentDate= datetime('now','timezone','utc') - days(152);

display(currentDate);

mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;


climateTargets     = mintsDefinitions.climateTargets;
pmTargets          = mintsDefinitions.pmTargets;
allTargets         = [climateTargets,pmTargets]


rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/results/";
scanFolder         =  dataFolder + "/liveUpdate/scan/";
modelsFolder       =  dataFolder + "/modelsMats/UTDNodes/";

timeSpan           =  seconds(mintsDefinitions.timeSpan);
nodeID             =  nodeIDs{nodeIndex}.nodeID;
display(nodeID);

timeFile         =  strcat(scanFolder,"t_"+nodeID,".mat")
folderCheck(timeFile)
display(timeFile);

todaysNodeFolder   = strcat(rawFolder,"/",nodeID,"/",...
    num2str(year(currentDate),'%04d'),"/",...
    num2str(month(currentDate),'%02d'),"/",...
    num2str(day(currentDate),'%02d'))    ;

resultsFile        = modelsFolder+ "WSInitial.csv";

display(newline);
display("Data Folder Located      @ :"+ dataFolder);
display("Raw Data Located         @ :"+ rawFolder );
display("Raw DotMat Data Located  @ :"+ rawMatsFolder);
display("Update Data Located      @ :"+ updateFolder);
display("Results File Located     @ :"+ resultsFile);
display(newline)


%% Get todays Raw Data
BME280Files      =  dir(strcat(todaysNodeFolder,'/*BME280*.csv'));
GPSGPGGA2Files   =  dir(strcat(todaysNodeFolder,'/*GPSGPGGA2*.csv'));
OPCN2Files       =  dir(strcat(todaysNodeFolder,'/*OPCN2*.csv'));
OPCN3Files       =  dir(strcat(todaysNodeFolder,'/*OPCN3*.csv'));

if isempty(BME280Files)||(isempty(OPCN2Files)&&isempty(OPCN3Files))
    display("No Data for Node:" +  nodeID)
    return;
end

display(newline)
display("Reading Raw Data")

BME280        = getSyncedDataV2Sub(BME280Files,"BME280",timeSpan);
OPCN2         = getSyncedDataV2Sub(OPCN2Files,"OPCN2",timeSpan);
OPCN3         = getSyncedDataV2Sub(OPCN3Files,"OPCN3",timeSpan);
GPSGPGGA2     = getSyncedDataV2Sub(GPSGPGGA2Files,"GPSGPGGA2",timeSpan);

% Defining how may stacks to use
% climate stack and PM stack
eval(strcat("sensorStack = mintsDefinitions.sensorStack_",nodeIDs{nodeIndex}.climateStack,";"))

eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"))
eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"))

eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"))

eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmAppendLabels       = mintsDefinitions.pmAppendLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))

allInputs                = [pmInputs,climateInputs];
pmInputsWithAppends      = [pmInputs,pmAppends];
pmInputLabelsWithAppends = [pmInputLabels,pmAppendLabels];

display(newline)
display("Saving UTD Nodes Data");
concatStr  =  "latestData  = synchronize(";
for stackIndex = 1: length(sensorStack)
    concatStr = strcat(concatStr,sensorStack{stackIndex},",");
end
concatStr  = strcat(concatStr,"'union');")   ;
eval(concatStr)

%% Get rows to be calibrated
printName=getPrintName(updateFolder,nodeID,currentDate,'calibrated');
csvAvailable =     isfile(printName);


%% Defining how may stacks to use
% climate stack and PM stack

% trainingAll = rmmissing(utdMints(:,[pmInputs,climateInputs]))   ;
% inCalib     = table2array(removevars(timetable2table(trainingAll(:,climateInputs)),'dateTime'));
%
% Calibrated_temperature = predictrnn(climateModels{1},inCalib);
% Calibrated_humidity    = predictrnn(climateModels{2},inCalib);
% Calibrated_pressure    = predictrnn(climateModels{3},inCalib);
%
% trainingPM   = addvars(trainingAll,...
%                         Calibrated_temperature,...
%                         Calibrated_humidity,...
%                         Calibrated_pressure);
%
% % if enough data was recorded
% if (height(trainingPM)<100)
%     display(strcat("Not enough PM Data points for Node: ",nodeID));
%     return
% end
%
% pmWithTargets   =  rmmissing(synchronize(trainingPM,palasWSTC,'intersection'));
%
% pmInputsWithAppends      = [pmInputs,pmAppends];
% pmInputLabelsWithAppends = [pmInputLabels,pmAppendLabels];


if csvAvailable
    currentTime  =  load(timeFile).nextTime;
    in           =  rmmissing(latestData(latestData.dateTime>currentTime,allInputs));
    finalPre     =  in(in.dateTime>currentTime,contains(in.Properties.VariableNames,"binCount"));
    strCombine   = "finalPost = timetable(in.dateTime(latestData.dateTime>currentTime)";
else
    currentTime  = datetime(2016,1,1,'timezone','utc')
    in           = rmmissing(latestData(:,allInputs));
    finalPre     = in(:,contains(in.Properties.VariableNames,"binCount"));
    strCombine   = "finalPost = timetable(in.dateTime";
end

inClimate  = table2array(in(:,climateInputs));

nextTime = latestData.dateTime(end);

if currentTime == nextTime
    display("No new Data for Node:" +  nodeID)
    return;
end

display(newline)


%% Loading the appropriate models
display(newline)
display("Loading Best Models")

[climateModels,climateModelLabels] = readResultsNow2(resultsFile,nodeID,climateTargets,modelsFolder);
%   bestModelsLabels;

if(sum(cellfun(@isempty,climateModels))>0 || length(climateModels)<4)
    display("Insuffient Number of Models Saved for Node:" +  nodeID)
    return;
end

[pmModels,pmModelLabels] = readResultsNow2(resultsFile,nodeID,pmTargets,modelsFolder);
%   bestModelsLabels;

if(sum(cellfun(@isempty,pmModels))>0 || length(pmModels)<4)
    display("Insuffient Number of Models Saved for Node:" +  nodeID)
    return;
end


display("Gaining Super Learner Predictions For climate models ")

for n = 1: length(climateModels)
    eval(strcat(climateTargets{n},"_predicted= " , "predictrnn(climateModels{n},inClimate);"));
end

for n = 1: length(climateModels)
    strCombine = strcat(strCombine,",",climateTargets{n},"_predicted");
end

inPmPre  = renamevars(addvars(in,...
    temperature_airmar_predicted,...
    pressure_airmar_predicted,...
    humidity_airmar_predicted) ...
    ,["temperature_airmar_predicted",...
    "pressure_airmar_predicted",...
    "humidity_airmar_predicted"],...
    ["Calibrated_temperature",...
    "Calibrated_pressure",...
    "Calibrated_humidity"]);


inPM  = table2array(inPmPre(:,pmInputsWithAppends));

for n = 1: length(pmModels)
    eval(strcat(pmTargets{n},"_predicted= " , "predictrnn(pmModels{n},inPM);"));
end

for n = 1: length(pmModels)
    strCombine = strcat(strCombine,",",pmTargets{n},"_predicted");
end

eval(strcat(strCombine,");"));

finalPost.Properties.VariableNames = ...
    strrep(strrep(allTargets +"_predicted","_palas",""),"_airmar","");

% finalPost = removevars(timetable2table(finalPost),"dateTime");
if isempty(GPSGPGGA2)
    GPSGPGGA2 = table();
    GPSGPGGA2.dateTime = currentDate;
    GPSGPGGA2.latitudeCoordinate = nan;
    GPSGPGGA2.longitudeCoordinate = nan;
    GPSGPGGA2.altitude = nan;
    GPSGPGGA2 = table2timetable(GPSGPGGA2);
end

predictedFinal = synchronize(GPSGPGGA2,synchronize(finalPre,finalPost),'last');
% predictedFinal = predictedFinal(height(predictedFinal)-height(finalPost)+2:end-1,:);
predictedFinal.GPSGPGGA2_altitude(isnan(predictedFinal.GPSGPGGA2_altitude))=...
                                        nodeIDs{nodeIndex}.altitude;
predictedFinal.GPSGPGGA2_latitudeCoordinate(isnan(predictedFinal.GPSGPGGA2_latitudeCoordinate))=...
                                        nodeIDs{nodeIndex}.latitude;
predictedFinal.GPSGPGGA2_longitudeCoordinate(isnan(predictedFinal.GPSGPGGA2_longitudeCoordinate))=...
                                        nodeIDs{nodeIndex}.longitude;

display("Applying Corrections")
predictedFinal.pm1_predicted((predictedFinal.pm1_predicted<0),:)=0;
predictedFinal.pm2_5_predicted((predictedFinal.pm2_5_predicted<0),:)=0;
predictedFinal.pm4_predicted((predictedFinal.pm4_predicted<0),:)=0;
predictedFinal.pm10_predicted((predictedFinal.pm10_predicted<0),:)=0;


predictedFinal.pm4_predicted((predictedFinal.pm2_5_predicted>predictedFinal.pm4_predicted),:) =...
    predictedFinal.pm2_5_predicted((predictedFinal.pm2_5_predicted>predictedFinal.pm4_predicted),:) ;

predictedFinal.pm1_predicted((predictedFinal.pm1_predicted>predictedFinal.pm2_5_predicted),:) =...
    predictedFinal.pm2_5_predicted((predictedFinal.pm1_predicted>predictedFinal.pm2_5_predicted),:) ;

predictedFinal.pm10_predicted((predictedFinal.pm4_predicted>predictedFinal.pm10_predicted),:) =...
    predictedFinal.pm4_predicted((predictedFinal.pm4_predicted>predictedFinal.pm10_predicted),:) ;

%% Checks

varNames = predictedFinal.Properties.VariableNames;

for n = 1 :length(varNames)
    varNames{n} =   strrep(varNames{n},'OPCN2_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'OPCN3_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'pm1_predicted','PM 1');
    varNames{n} =   strrep(varNames{n},'pm2_5_predicted','PM 2.5');
    varNames{n} =   strrep(varNames{n},'pm4_predicted','PM 4');
    varNames{n} =   strrep(varNames{n},'pm10_predicted','PM 10');
    varNames{n} =   strrep(varNames{n},'temperature_predicted','Temperature');
    varNames{n} =   strrep(varNames{n},'humidity_predicted','Humidity');
    varNames{n} =   strrep(varNames{n},'pressure_predicted','Pressure');
    varNames{n} =   strrep(varNames{n},'dewPoint_predicted','Dew Point');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_latitudeCoordinate','Latitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_longitudeCoordinate','Longitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_altitude','Altitude');
end

predictedFinal.Properties.VariableNames = varNames;
predictedFinal.dateTime.Format =  'uuuu-MM-dd HH:mm:ss.SSS';

if csvAvailable
    writetimetable(predictedFinal,printName,'WriteMode','append','WriteVariableNames',false)
else
    writetimetable(predictedFinal,  printName)
end

save(timeFile,'nextTime');

printCSVT(climateModelLabels,updateFolder,nodeID,currentDate,'modelInfo');

display(newline)
toc

display(newline)
display("MINTS Done")


end

