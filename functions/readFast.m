function mintsData = readFast(fileName,timeSpan)
   
    mintsData                       = retime(table2timetable(tabularTextDatastore(fileName).read),...
                                                'regular',@mean,'TimeStep',timeSpan);
    mintsData.dateTime.TimeZone = "utc";

end