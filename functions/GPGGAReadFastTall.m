function mintsData = GPGGAReadFast(fileName,timeSpan)
    
    mintsData                       =tabularTextDatastore(fileName);
    mintsData.SelectedVariableNames =  {'dateTime', 'latitudeCoordinate', 'longitudeCoordinate','altitude'};
    mintsData                       = retime(table2timetable(mintsData),'regular',@mean,'TimeStep',timeSpan);
    mintsData = mintsData,
    mintsData.dateTime.TimeZone = "utc";
end

