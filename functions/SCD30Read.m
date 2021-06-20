function mintsData = SCD30Read(filename,timeSpan)
    
    %% Input handling

    % If dataLines is not specified, define defaults
    dataLines = [2, Inf];

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 4);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "c02", "temperature", "humidity"];
    opts.VariableTypes = ["datetime", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");

    % Import the data
    mintsData = readtable(filename, opts);
    
    mintsData   =  retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan);
    
    mintsData.dateTime.TimeZone = "utc";
    
     %% Clear temporary variables
    clear opts
    
    

end