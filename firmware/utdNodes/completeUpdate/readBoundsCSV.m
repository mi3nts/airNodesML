function  completeBounds = readBoundsCSV(fileName)

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["versionStr", "nodeID", "temperatureOOBPer", "pressureOOBPer", "humidityOOBPer", "temperatureOOBPerLatest", "pressureOOBPerLatest", "humidityOOBPerLates", "temperatureOOBPerWeekly", "pressureOOBPerWeekly", "humidityOOBPerWeekly"];
opts.VariableTypes = ["string", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "versionStr", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["versionStr", "nodeID"], "EmptyFieldRule", "auto");

% Import the data
completeBounds = readtable(fileName, opts);


%% Clear temporary variables
clear opts




end
