function mintsData = GPGGAReadFast(fileName,timeSpan)
    
    mintsData                       =tabularTextDatastore(fileName,'OutputType', 'timetable');
    mintsData.SelectedVariableNames =  {'dateTime', 'latitudeCoordinate', 'longitudeCoordinate','altitude'};
    mintsData                       = retime(mintsData.read,'regular',@mean,'TimeStep',timeSpan);
    mintsData.dateTime.TimeZone = "utc";
end

