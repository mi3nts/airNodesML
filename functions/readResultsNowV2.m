function [bestModels,bestModelsLabels,climateParamsNow]  = readResultsNowV2(fileName,nodeID,mintsTargets,modelsFolder)

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 17);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["rmseTrain", "rSquaredTrain", "rmseValid", "rSquaredValid", "rmse", "rSquared", "pValid", "nodeID", "target", "binsPerColumn", "numberPerBin", "minLayers", "maxLayers", "MaxEvaluations", "trainRows", "validRows", "versionStr"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["nodeID", "target", "versionStr"], "EmptyFieldRule", "auto");

% Import the data
results = readtable(fileName, opts);

nodeResults = results(results.nodeID == nodeID,:);

for n = 1 : length(mintsTargets)
    targetResults    = nodeResults(nodeResults.target==mintsTargets{n},:);
    [maxRes, maxInd] = max(targetResults.rSquaredValid);
    %         isfile(getModelName(targetResults(maxInd,:),modelsFolder,mintsTargets{n}))
    if isfile(getModelName(targetResults(maxInd,:),modelsFolder,mintsTargets{n}));
        bestModels{n} = load(getModelName(targetResults(maxInd,:),modelsFolder,mintsTargets{n})).Mdl;
        climateParams{n} = load(getModelName(targetResults(maxInd,:),modelsFolder,mintsTargets{n})).climateParams;
        bestModelsLabels(n,:) = targetResults(maxInd,:);
    end
end


display("Climate Params");
% Get The Appropriate Climate Params

maxTemperatureK = climateParams{1}.maxTemperatureK;
minTemperatureK = climateParams{1}.minTemperatureK ;
maxPressureLog = climateParams{1}.maxPressureLog;
minPressureLog = climateParams{1}.minPressureLog ;
maxHumidity    = climateParams{1}.maxHumidity;
minHumidity    = climateParams{1}.minHumidity ;

for n = 1:length(bestModels)
    climateParamsNow.maxTemperatureK =   max(maxTemperatureK,climateParams{n}.maxTemperatureK);
    climateParamsNow.minTemperatureK =   min(minTemperatureK,climateParams{n}.minTemperatureK);
    climateParamsNow.maxPressureLog =   max(maxPressureLog,climateParams{n}.maxPressureLog);
    climateParamsNow.minPressureLog =   min(minPressureLog,climateParams{n}.minPressureLog);
    climateParamsNow.maxHumidity  =   max(maxHumidity ,climateParams{n}.maxHumidity );
    climateParamsNow.minHumidity  =   min(minHumidity ,climateParams{n}.minHumidity );   
end

%% Clear temporary variables
clear opts
end
