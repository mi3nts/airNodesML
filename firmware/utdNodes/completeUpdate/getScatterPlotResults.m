function []  =  getScatterPlotResults(nodeIndex)

currentDate= datetime('now','timezone','utc');
display(newline)
% display("---------------------MINTS---------------------")

addpath("../../../functions/")
addpath("../../../functions/ZipLatLon")
addpath("../../../YAMLMatlab_0.4.3")

yamlFile =  '../mintsDefinitionsV2.yaml';

mintsDefinitions   = ReadYaml(yamlFile);

nodeIDs            = mintsDefinitions.nodeIDs;
dataFolder         = mintsDefinitions.dataFolder;

rawFolder          =  dataFolder + "/raw";
rawMatsFolder      =  dataFolder + "/rawMats";
updateFolder       =  dataFolder + "/liveUpdate/UTDNodes";
visualFolder       =  dataFolder + "/visualAnalysis/UTDNodes";
modelsFolder       =  dataFolder + "/modelsMats/UTDNodes/";

timeSpan           =  seconds(mintsDefinitions.timeSpan);
nodeID             =  nodeIDs{nodeIndex}.nodeID;
resultsFile        = modelsFolder+ "WSInitialV2.csv";

targets      = mintsDefinitions.targets;

display("Getting Historic Update for Node: "+ nodeID);
display("Currrent Time is "+ datestr(datetime('now')));
display("---------------------MINTS---------------------")

% versionStrPreHistoric = 'UTD_V2_Historic_';

%% Loading from previiously Saved Data files
% loadName = strcat(rawMatsFolder,"/UTDNodes/Mints_UTD_Node_",nodeID,"_30Sec.mat");
% load(loadName)
%
% mintsDataUTD = nodeFixes(nodeID,mintsDataUTD,rawMatsFolder);

%% Choosing Input Stack
% eval(strcat("climateInputs        = mintsDefinitions.climateStack_",nodeIDs{nodeIndex}.climateStack,";"));
% eval(strcat("climateInputsCalib   = mintsDefinitions.climateInputsCalib_",nodeIDs{nodeIndex}.climateStack,";"));
% eval(strcat("climateInputLabels   = mintsDefinitions.climateStackLabels_",nodeIDs{nodeIndex}.climateStack,";"));

% eval(strcat("pmInputs             = mintsDefinitions.pmStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmInputsCorrected    = mintsDefinitions.pmInputsCorrected_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmInputLabels        = mintsDefinitions.pmStackLabels_",string(nodeIDs{nodeIndex}.pmStack),";"))
% eval(strcat("pmAppends            = mintsDefinitions.pmAppends_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("pmAppendsCalib       = mintsDefinitions.pmAppendsCalib_",string(nodeIDs{nodeIndex}.pmStack),";"));

% eval(strcat("sensorStack          = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"));
% eval(strcat("csvStack             = mintsDefinitions.csvStack_",string(nodeIDs{nodeIndex}.pmStack),";"));

% %% Defining Inputs
% inCorrected  = correctionsUTDV2(mintsDataUTD);

% At this point I can load in the best model file

display("Moving Scatter Plots")
[bestModels,bestModelsLabels,climateParamsNow] = readResultsNowV2(...
    resultsFile,nodeID,targets,modelsFolder);
% for n = 1: height(bestModelsLabels)
sourcesIn      = strcat(visualFolder,...
    "/",nodeID,"/",...
    string(bestModelsLabels.versionStr),"/",...
   string(bestModelsLabels.versionStr),"_",...
      nodeID,...
   "_",string(bestModelsLabels.target),".png"...
    );

destinationsIn      = strcat(updateFolder,...
    "/",nodeID,"/summary/",...
       string(bestModelsLabels.target),"_", nodeID,...
   "_Scatter.png"...
    );



for n = 1: length(destinationsIn)

  source      = sourcesIn(n)  ;
  destination = destinationsIn(n)  ;
  folderCheck(destination)
  status = copyfile( source , destination);
end


end
