
function [] = dailyUpdateLive(nodeIndex,daysBack)

display(newline)
% display("---------------------MINTS---------------------")

addpath("../../../functions/")
addpath("../../../functions/ZipLatLon")

% load('../../../functions/ZipLatLon/ZipMap.mat')

addpath("../../../YAMLMatlab_0.4.3")

yamlFile =  '../mintsDefinitionsV2.yaml';

mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;

rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/results/";
modelsFolder       =  dataFolder + "/modelsMats/UTDNodes/";

timeSpan           =  seconds(mintsDefinitions.timeSpan);
nodeID             =  nodeIDs{nodeIndex}.nodeID;
resultsFile        = modelsFolder+ "WSInitialV2.csv";

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

versionStrPreDaily = 'UTD_V2_Daily_';
versionStrDaily    = [versionStrPreDaily datestr(now,'yyyy_mm_dd_HH_MM_SS')];

dataDate= datetime('today','timezone','utc') - days(daysBack);



%% Loading from previiously Saved Data files
loadName = strcat(rawMatsFolder,"/UTDNodes/Mints_UTD_Node_",nodeID,"_30Sec.mat");
load(loadName)
%%
mintsDataUTD = mintsDataUTD(year(mintsDataUTD.dateTime) == year(dataDate)&...
         month(mintsDataUTD.dateTime) == month(dataDate)&...
            day(mintsDataUTD.dateTime) == day(dataDate),:);

        
% if enough data was recorded
if (height(mintsDataUTD)<100)
    display(strcat("No Data for: ",nodeID, " for " ,string(dataDate)));
    return
end        

mintsDataUTD = nodeFixes(nodeID,mintsDataUTD,rawMatsFolder);




%% Choosing Input Stack
eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputsCalib   = mintsDefinitions.climateInputsCalib_",nodeIDs{nodeIndex}.climateStack,";"));
eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"));

eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))
eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("pmAppendsCalib       = mintsDefinitions.pmAppendsCalib_",string(nodeIDs{nodeIndex}.pmStack),";"));

eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
eval(strcat("csvStack             = mintsDefinitions.csvStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

%% Defining Inputs
inCorrected  = correctionsUTDV2(mintsDataUTD);

% At this point I can load in the best model file
display("Loading Best Models")
[bestModels,bestModelsLabels,climateParamsNow] = readResultsNowV2(...
                        resultsFile,nodeID,targets,modelsFolder);

display("Climate Bounding")

% Global Bounds 
inCorrected = checkBoundsDaily(inCorrected);
% Training Bounds 

if height(inCorrected)<2
    display("Sensor Error For:" +  nodeID)
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
    display("Predicting " + targets{n})
    eval(strcat("inCorrected.",targets{n},"_predicted= " , "predict(bestModels{n},inPM);"));
end

%% Applying Corrections
inCorrected =  correctionsPM(inCorrected);
inCorrected.temperatureOut = inCorrected.temperatureCalib;
inCorrected.pressureOut    = 10.^(inCorrected.pressureCalib);
inCorrected.humidityOut    = inCorrected.humidityCalib;
inCorrected.dewPointOut    = inCorrected.dewPoint_predicted;

%% GPS Coordinates 

lat = rmmissing(inCorrected.GPSGPGGA2_latitudeCoordinate);
long = rmmissing(inCorrected.GPSGPGGA2_longitudeCoordinate);
if ~isnan(lat)
lat = lat(end);
long = long(end);
zip = getZip(lat,long);
    gpsString =  "(" + lat + "," + long +")" + " Zip Code: " +string(zip);  
else
    gpsString =  " ";
end 


preFigName = strrep(getPrintName(updateFolder,nodeID,dataDate,"daily"),".csv","")

%% Climate Graphs 
drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.temperatureOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Temperature (K)",...
    strcat("Atmospheric Temperature - ",strrep(string(bestModelsLabels.versionStr(1)),"_","-")),...
    "Atmospheric Temperature Time Series",...
     preFigName +"_Temperature.png",...
    true,...
    0,120,gpsString)

drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.pressureOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Pressure (mili Bar)",...
    strcat("Atmospheric Pressure: ",strrep(string(bestModelsLabels.versionStr(2)),"_","-")),...
    "Atmospheric Pressure Time Series",...
     preFigName+"_Pressure.png",...
    true,...
    975,1010,gpsString)


drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.humidityOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Humidity (%)",...
    strcat("Atmospheric Humidity: ",strrep(string(bestModelsLabels.versionStr(3)),"_","-")),...
    "Atmospheric Humidity Time Series",...
     preFigName+"_Humidity.png",...
    true,...
    0,100,gpsString)

drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.dewPoint_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Dew Point (K)",...
    strcat("Dew Point: ",strrep(string(bestModelsLabels.versionStr(4)),"_","-")),...
    "Dew Point Time Series",...
     preFigName+"_DewPoint.png",...
    true,...
    -20,100,gpsString)

%% Pm Graphs 

drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.pm1_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{1} (\mug/m^{3})",...
    strcat("PM_{1}: ",strrep(string(bestModelsLabels.versionStr(5)),"_","-")),...
    "PM_{1} Time Series",...
     preFigName+"_PM1.png",...
    true,...
    0,40,gpsString)

drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.pm2_5_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{2.5} (\mug/m^{3})",...
    strcat("PM_{2.5}: ",strrep(string(bestModelsLabels.versionStr(6)),"_","-")),...
    "PM_{2.5} Time Series",...
     preFigName+"_PM2_5.png",...
    true,...
    0,50,gpsString)

drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.pm4_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{4} (\mug/m^{3})",...
    strcat("PM_{4}: ",strrep(string(bestModelsLabels.versionStr(7)),"_","-")),...
    "PM_{4} Time Series",...
     preFigName+"_PM4.png",...
    true,...
    0,60,gpsString)
drawSummary1x3Title(...
    inCorrected.dateTime,inCorrected.pm10_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{10} (\mug/m^{3})",...
    strcat("PM_{10}: ",strrep(string(bestModelsLabels.versionStr(8)),"_","-")),...
    "PM_{10} Time Series",...
     preFigName+"_PM10.png",...
    true,...
    0,100,gpsString)

drawSummary3x3Title(...
    inCorrected.dateTime,inCorrected.pm1_palas_predicted,...
    inCorrected.dateTime,inCorrected.pm2_5_palas_predicted,...
    inCorrected.dateTime,inCorrected.pm10_palas_predicted,...
       strcat("PM_{1}  : ",strrep(string(bestModelsLabels.versionStr(5)),"_","-")),...
         strcat("PM_{2.5}: ",strrep(string(bestModelsLabels.versionStr(6)),"_","-")),...
          strcat("PM_{10} :  ",strrep(string(bestModelsLabels.versionStr(7)),"_","-")),...
            nodeID,"Date Time (UTC)","PM (\mug/m^{3})",... 
              75,...
               "Particulate Matter Summary Plot",...
                preFigName +"_PMSummary.png",gpsString)


%% UNCOMMENT ON EUROPA
contourOPCSummary3Title(...
    inCorrected,...
    nodeID,...
    "Date Time (UTC)",...
     "Particle Diametor",...
     "Contour Plot for Binned Particle Counts", preFigName +"_Contour.png",gpsString);

display(" ");


% printName= updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Raw_Historic.mat";
% display("MINTS Saving: " +printName)
% save( printName,'inCorrected');

varNames = inCorrected.Properties.VariableNames;

for n = 1 :length(varNames)
    varNames{n} =   strrep(varNames{n},'OPCN2_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'OPCN3_binCount','Bin');
    varNames{n} =   strrep(varNames{n},'pm1_palas_predicted','PM 1');
    varNames{n} =   strrep(varNames{n},'pm2_5_palas_predicted','PM 2.5');
    varNames{n} =   strrep(varNames{n},'pm4_palas_predicted','PM 4');
    varNames{n} =   strrep(varNames{n},'pm10_palas_predicted','PM 10');
    varNames{n} =   strrep(varNames{n},'temperatureOut','Temperature');
    varNames{n} =   strrep(varNames{n},'pressureOut','Pressure');
    varNames{n} =   strrep(varNames{n},'humidityOut','Humidity');
    varNames{n} =   strrep(varNames{n},'dewPointOut','Dew Point');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_latitudeCoordinate','Latitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_longitudeCoordinate','Longitude');
    varNames{n} =   strrep(varNames{n},'GPSGPGGA2_altitude','Altitude');
end

inCorrected.Properties.VariableNames = varNames;
inCorrected.dateTime.Format =  'uuuu-MM-dd HH:mm:ss.SSS';

predictedFinal =  inCorrected(:,csvStack);
printName=getPrintName(updateFolder,nodeID,dataDate,'calibrated');
writetimetable(predictedFinal,  printName);

printCSVT(bestModelsLabels,updateFolder,nodeID,dataDate,'modelInfoLive');

display("MINTS Done");
end

%% 5a61 : Aug 2021, Oct 10 - Now
%% 5a12 : Sep - Oct 10 @ Joppa

