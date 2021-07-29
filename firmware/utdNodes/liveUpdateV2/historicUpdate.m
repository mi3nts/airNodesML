function [] = historicUpdate(nodeIndex)

display(newline)
display("---------------------MINTS---------------------")
addpath("../../../functions/")

addpath("../../../YAMLMatlab_0.4.3")

startDate = datetime(2018,1,1,'timezone','utc');
endDate = datetime('now','timezone','utc') - days(1);
yamlFile =  '../mintsDefinitionsV2.yaml';
mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;

rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/UTDNodes";
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
%% Loading from previiously Saved Data files
loadName = strcat(rawMatsFolder,"/UTDNodes/Mints_UTD_Node_",nodeID,".mat");
load(loadName)

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

%% Defining Inputs
inCorrected  = correctionsUTDV2(mintsDataUTD);

% At this point I can load in the best model file
display("Loading Best Models")
[bestModels,bestModelsLabels,climateParamsNow] = readResultsNowV2(resultsFile,nodeID,targets,modelsFolder);

display("Climate Bounding")

% Probably and if Statement Goes here
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



preFigName  =  updateFolder+"/"+nodeID+"/Mints_"+nodeID;

%% Climate Graphs 
drawSummary1x(...
    inCorrected.dateTime,inCorrected.temperatureOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Temperature (K)",...
    strcat("Atmospheric Temperature - ",strrep(string(bestModelsLabels.versionStrMdl(1)),"_","-")),...
    "Atmospheric Temperature Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Temperature.png",...
    true,...
    0,100)

drawSummary1x(...
    inCorrected.dateTime,inCorrected.pressureOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Pressure (mili Bar)",...
    strcat("Atmospheric Pressure: ",strrep(string(bestModelsLabels.versionStrMdl(2)),"_","-")),...
    "Atmospheric Pressure Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Pressure.png",...
    true,...
    975,1010)


drawSummary1x(...
    inCorrected.dateTime,inCorrected.humidityOut,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Atmospheric Humidity (%)",...
    strcat("Atmospheric Humidity: ",strrep(string(bestModelsLabels.versionStrMdl(3)),"_","-")),...
    "Atmospheric Humidity Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_Humidity.png",...
    true,...
    0,100)

drawSummary1x(...
    inCorrected.dateTime,inCorrected.dewPoint_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "Dew Point (K)",...
    strcat("Dew Point: ",strrep(string(bestModelsLabels.versionStrMdl(4)),"_","-")),...
    "Dew Point Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_DewPoint.png",...
    true,...
    -20,100)

%% Pm Graphs 

drawSummary1x(...
    inCorrected.dateTime,inCorrected.pm1_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{1} (\mug/m^{3})",...
    strcat("PM_{1}: ",strrep(string(bestModelsLabels.versionStrMdl(5)),"_","-")),...
    "PM_{1} Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_PM1.png",...
    true,...
    0,40)

drawSummary1x(...
    inCorrected.dateTime,inCorrected.pm2_5_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{2.5} (\mug/m^{3})",...
    strcat("PM_{2.5}: ",strrep(string(bestModelsLabels.versionStrMdl(6)),"_","-")),...
    "PM_{2.5} Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_PM2_5.png",...
    true,...
    0,50)

drawSummary1x(...
    inCorrected.dateTime,inCorrected.pm4_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM_{4} (\mug/m^{3})",...
    strcat("PM_{4}: ",strrep(string(bestModelsLabels.versionStrMdl(7)),"_","-")),...
    "PM_{4} Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_PM4.png",...
    true,...
    0,60)
drawSummary1x(...
    inCorrected.dateTime,inCorrected.pm10_palas_predicted,...,...
    nodeID,...
    "Date Time (UTC)",...
    "PM (\mug/m^{3})",...
    strcat("PM_{10}: ",strrep(string(bestModelsLabels.versionStrMdl(8)),"_","-")),...
    "PM_{10} Time Series",...
     updateFolder+"/"+nodeID+"/Mints_"+nodeID+"_PM10.png",...
    true,...
    0,100)

drawSummary3x(...
    inCorrected.dateTime,inCorrected.pm1_palas_predicted,...
    inCorrected.dateTime,inCorrected.pm2_5_palas_predicted,...
    inCorrected.dateTime,inCorrected.pm10_palas_predicted,...
       strcat("PM_{1}  : ",strrep(string(bestModelsLabels.versionStrMdl(5)),"_","-")),...
         strcat("PM_{2.5}: ",strrep(string(bestModelsLabels.versionStrMdl(6)),"_","-")),...
          strcat("PM_{10} :  ",strrep(string(bestModelsLabels.versionStrMdl(7)),"_","-")),...
            nodeID,"Date Time (UTC)","PM (\mug/m^{3})",... 
              75,...
               "Particulate Matter Summary Plot",...
                preFigName +"_PMSummary.png")



contourOPCSummary(...
    inCorrected,...
    nodeID,...
    "Date Time (UTC)",...
     "Particle Counts",...
     "Contour Plot for Binned Particle Counts", preFigName +"_Countour.png")

display(" ");

% OPC Bin Count Graphs 




% datesIn = endDate: -days(1): startDate ;
% 
% display("Going through each date")
% 
% for dateIndex  = 1:length(datesIn)
%     
%     currentDate = datesIn(dateIndex);
%     printName=getPrintName(updateFolder,nodeID,currentDate,'calibrated');
%     
%     yearIn      = year(currentDate);
%     monthIn     = month(currentDate);
%     dateIn       = day(currentDate);
%     
%     
%     
%     validDaysInd= (day(mintsDataAll.dateTime)==dateIn)&...
%         ((month(mintsDataAll.dateTime)==monthIn)&...
%         (year(mintsDataAll.dateTime)==yearIn));
%     
%     In = InPre(validDaysInd,:);
%     mintsData = mintsDataAll(validDaysInd,:) ;
%     
%     
%     
%     if (height(mintsData)>0)
%         tic
%         %% Loading the appropriate models
%         
%         display("Gaining Predictions for Node:" + nodeID + " for the date of " + ...
%             yearIn +" " + monthIn+ " " + dateIn )
%         
%         for n = 1: length(bestModels)
%             display("Predicting " + mintsTargets{n})
%             eval(strcat(mintsTargets{n},"_predicted= " , "predictrsuper(bestModels{n},In);"));
%         end
%         
%         
%         predictedTablePre2 = mintsData(:,contains(mintsData.Properties.VariableNames,"GPSGPGGA2"));
%         
%         predictedTablePre = mintsData(:,contains(mintsData.Properties.VariableNames,"binCount"));
%         
%         
%         strCombine = "predictedTablePost = timetable(mintsData.dateTime";
%         
%         for n = 1: length(bestModels)
%             strCombine = strcat(strCombine,",",mintsTargets{n},"_predicted");
%         end
%         
%         eval(strcat(strCombine,");"));
%         
%         predictedTablePost.Properties.VariableNames =  strrep(strrep(mintsTargets+"_Predicted","_palas",""),"_Airmar","");
%         
%         
%         
%         predictedTable = [predictedTablePre2,predictedTablePre,predictedTablePost];
%         
%         varNames = predictedTable.Properties.VariableNames;
%         
%         for n = 1 :length(varNames)
%             varNames{n} =   strrep(varNames{n},'latitudeCoordinate','Latitude');
%             varNames{n} =   strrep(varNames{n},'longitudeCoordinate','Longitude');
%             varNames{n} =   strrep(varNames{n},'altitude','Altitude');
%         end
%         
%         
%         
%         display("Gaining Prediction")
%         predictedTablePre  = predictedTable;
%         predictionCorrection = zeros(height(predictedTable),1);
%         
%         
%         
%         
%         %% Checks
%         
%         
%         
%         close all
%         figure_1= figure('Tag','SCATTER_PLOT',...
%             'NumberTitle','off',...
%             'units','pixels','OuterPosition',[0 0 900 675],...
%             'Name','TimeSeries',...
%             'Visible','off'...
%             );
%         
%         plot(predictedTable.dateTime,predictedTable.pm10_Predicted,'k-')
%         hold on
%         plot(predictedTable.dateTime,predictedTable.pm4_Predicted,'b-')
%         plot(predictedTable.dateTime,predictedTable.pm2_5_Predicted,'g-')
%         plot(predictedTable.dateTime,predictedTable.pm1_Predicted,'r-')
%         
%         
%         
%         legend('on')
%         
%         legend('PM_{10}','PM_{4}','PM_{2.5}','PM_{1}')
%         
%         
%         ylabel(strcat("PM Levels (\mug/m^{3})"),'FontWeight','bold','FontSize',10);
%         
%         % Create xlabel
%         xlabel('Date Time','FontWeight','bold','FontSize',10);
%         
%         %     % Create title
%         Top_Title=strcat("PM Levels");
%         
%         Bottom_Title = strcat("Node " +string(nodeID));
%         
%         title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
%         
%         
%         outFigNamePre    = strcat(updateFolder,"/",nodeID,"/",...
%             num2str(yearIn,'%04d'),"/",...
%             num2str(monthIn,'%02d'),"/",...
%             num2str(dateIn,'%02d'),"/",...
%             "MINTS_",...
%             nodeID,...
%             "_",stringIn,"_",...
%             num2str(yearIn,'%02d'),"_",...
%             num2str(monthIn,'%02d'),"_",...
%             num2str(dateIn,'%02d')...
%             );
%         
%         
%         
%         
%         Fig_name = strcat(outFigNamePre,'.png');
%         folderCheck(Fig_name);
%         saveas(figure_1,char(Fig_name));
%         
%         varNames = predictedTable.Properties.VariableNames;
%         
%         
%         for n = 1 :length(varNames)
%             varNames{n} =   strrep(varNames{n},'binCount','Bin');
%             varNames{n} =   strrep(varNames{n},'_Predicted','');
%             varNames{n} =   strrep(varNames{n},'Airmar','');
%             varNames{n} =   strrep(varNames{n},'pm','PM');
%             varNames{n} =   strrep(varNames{n},'temperature','Temperature');
%             varNames{n} =   strrep(varNames{n},'humidity','Humidity');
%             varNames{n} =   strrep(varNames{n},'pressure','Pressure');
%             varNames{n} =   strrep(varNames{n},'dewPoint','DewPoint');
%             varNames{n} =   strrep(varNames{n},'dCn','ParticleConcentration');
%             varNames{n} =   strrep(varNames{n},'pressure','Pressure');
%             varNames{n} =   strrep(varNames{n},'latitudeCoordinate','Latitude');
%             varNames{n} =   strrep(varNames{n},'longitudeCoordinate','Longitude');
%             varNames{n} =   strrep(varNames{n},'altitude','Altitude');
%         end
%         
%         predictedTable.Properties.VariableNames = varNames;
%         writetimetable(predictedTable,printName)
%         toc
%     else
%         display("No Data For " +  nodeID +" (Year: "+ string(yearIn)+" Month:"+ string(monthIn) +")");
%     end % Enough Mints Data
%     
%     clearvars -except bestModels bestModelsLabels columns currentDate dataFolder dateIndex ...
%         datesIn dayIn dCn_palas_predicted dewPointAirmar_predicted endDate humidityAirmar_predicted InPre ...
%         inputStack latestStack loadName mintsDataAll mintsDefinitions mintsInputLabels mintsInputs ...
%         mintsTargets modelsFolder monthIn n nodeID nodeIDs nodeIndex pm10_palas_predicted...
%         pm1_palas_predicted pm2_5_palas_predicted pm4_palas_predicted pmTotal_palas_predicted ...
%         pressureAirmar_predicted rawFolder rawMatsFolder resultsFile rows startDate stringIn ...
%         temperatureAirmar_predicted timeSpan updateFolder validDaysInd yamlFile yearIn
%     
% end % Ending Current Date
nodeID
end

%% 5a61 : Aug 2021, Oct 10 - Now
%% 5a12 : Sep - Oct 10 @ Joppa

