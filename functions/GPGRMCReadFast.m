
function mintsData = GPRMCReadFast(fileName,timeSpan)
tic
    mintsData                       = tabularTextDatastore(fileName);
    mintsData.SelectedVariableNames =  {'dateTime', 'latitudeCoordinate', 'longitudeCoordinate'};
    mintsData                       = retime(table2timetable(mintsData.read),'regular',@mean,'TimeStep',timeSpan);
    mintsData.dateTime.TimeZone = "utc";
toc
end
