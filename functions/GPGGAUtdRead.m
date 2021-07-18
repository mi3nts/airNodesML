function mintsData = GPGGARead(fileName,timeSpan)

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 17);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "timestamp", "latitudeCoordinate", "longitudeCoordinate", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "gpsQuality", "numberOfSatellites", "HorizontalDilution", "altitude", "altitudeUnits", "undulation", "undulationUnits", "age", "stationID"];
    opts.VariableTypes = ["datetime", "datetime", "double", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["age", "stationID"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["latitudeDirection", "longitudeDirection", "altitudeUnits", "undulationUnits", "age", "stationID"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
    opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");

    % Import the data
    mintsData = readtable(fileName, opts);
           
    mintsData = removevars( mintsData,{...    
                   'timestamp'          ,...
                   'latitude'           ,...
                   'latitudeDirection'  ,...
                   'longitude'          ,...
                   'longitudeDirection' ,...
                   'gpsQuality'         ,...
                   'numberOfSatellites' ,...
                   'HorizontalDilution' ,...       
                   'altitudeUnits'      ,...
                   'undulation'         ,...
                   'undulationUnits'    ,...
                   'age'                ,...
                   'stationID'          }...
               );
           
    
    mintsData.dateTime.TimeZone = "utc";

    mintsData           = rmmissing(retime(table2timetable(mintsData),'regular',@nanmean,'TimeStep',timeSpan));
%     fileParts = strsplit(fileName,'_');
%     mintsData.sensor(:) =fileParts(end-3);

   %% Clear temporary variables
    clear opts

end

