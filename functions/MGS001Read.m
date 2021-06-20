function mintsData = MGS001Read(filename,timeSpan)
    
    %% Input handling

    % If dataLines is not specified, define defaults
    dataLines = [2, Inf];


    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 9);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "nh3", "co", "no2", "c3h8", "c4h10", "ch4", "h2", "c2h5oh"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
    mintsData   =  readtable(filename, opts);
    
    mintsData   =  retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan);
    
    mintsData.dateTime.TimeZone = "utc";
    
     %% Clear temporary variables
    clear opts
    
    

end