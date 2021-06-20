function mintsData = OPCN2Read(filename,timeSpan)
    
    %% Input handling

    % If dataLines is not specified, define defaults
    dataLines = [2, Inf];

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 29);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "valid", "binCount0", "binCount1", "binCount2", "binCount3", "binCount4", "binCount5", "binCount6", "binCount7", "binCount8", "binCount9", "binCount10", "binCount11", "binCount12", "binCount13", "binCount14", "binCount15", "bin1TimeToCross", "bin3TimeToCross", "bin5TimeToCross", "bin7TimeToCross", "sampleFlowRate", "temperatureOrPressure", "samplingPeriod", "checkSum", "pm1", "pm2_5", "pm10"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

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