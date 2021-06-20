
function bestModels  = readResults(fileName,nodeID,mintsTargets,modelsFolder)

%   
    %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 10);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["rmseTrain", "rSquaredTrain", "rmseValid", "rSquaredValid", "rmse", "rSquared", "pValid", "nodeID", "target", "versionStrMdl"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "categorical"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["nodeID", "target", "versionStrMdl"], "EmptyFieldRule", "auto");

    % Import the data
    results = readtable(fileName, opts);

    nodeResults = results(results.nodeID == nodeID,:)

    for n = 1 : length(mintsTargets)
        targetResults    = nodeResults(nodeResults.target==mintsTargets{n},:)
        [maxRes, maxInd] = max(targetResults.rSquaredValid)
        bestModels{n}    = load(getModelName(targetResults(maxInd,:),modelsFolder,mintsTargets{n})).Mdl
    end     

    %% Clear temporary variables
    clear opts


end