function tableIn = checkBoundsDaily(tableIn)
display("Applying Bounds Daily")
% bounds = struct;
% bounds.versionStr = versionStr;
% bounds.nodeID = nodeID;
% latestWeek =datetime('now','timezone','utc') - days(7);

% tableInWeek = tableIn(tableIn.dateTime > latestWeek,:);
% 
% if height(tableIn)>1000
%     tableInLatest     = tableIn(end-1000:end,:);
% else 
%     tableInLatest     = tableIn;
% end

if sum(contains(tableIn.Properties.VariableNames,"BME280"))>0
    temperatureOOBIndex = tableIn.BME280_temperatureK>120 |tableIn.BME280_temperatureK<20;
    pressureOOBIndex    = tableIn.BME280_pressureLog>3.01|tableIn.BME280_pressureLog<2.98;
    humidityOOBIndex    = tableIn.BME280_humidity>100|tableIn.BME280_humidity<0;
   
    tableIn(temperatureOOBIndex|pressureOOBIndex|humidityOOBIndex,:) = [];
  
    
end

end