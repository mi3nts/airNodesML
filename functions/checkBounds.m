function tableIn = checkBounds(tableIn,nodeID,versionStr,modelsMatsFolder,fileName)
display("Applying Bounds")
bounds = struct;
bounds.versionStr = versionStr;
bounds.nodeID = nodeID;
latestWeek =datetime('now','timezone','utc') - days(7);

tableInWeek = tableIn(tableIn.dateTime > latestWeek,:);

if height(tableIn)>1000
    tableInLatest     = tableIn(end-1000:end,:);
else 
    tableInLatest     = tableIn;
end

if sum(contains(tableIn.Properties.VariableNames,"BME280"))>0
    temperatureOOBIndex = tableIn.BME280_temperatureK>120 |tableIn.BME280_temperatureK<20;
    pressureOOBIndex    = tableIn.BME280_pressureLog>3.01|tableIn.BME280_pressureLog<2.98;
    humidityOOBIndex    = tableIn.BME280_humidity>100|tableIn.BME280_humidity<0;
    temperatureOOB      = sum(temperatureOOBIndex);
    pressureOOB         = sum(pressureOOBIndex);
    humidityOOB         = sum(humidityOOBIndex);
    temperatureOOBPer   = 100*(temperatureOOB/height(tableIn));
    pressureOOBPer      = 100*(pressureOOB/height(tableIn));
    humidityOOBPer      = 100*(humidityOOB/height(tableIn));
    
    tableIn(temperatureOOBIndex|pressureOOBIndex|humidityOOBIndex,:) = [];
   
    bounds.temperatureOOBPer = temperatureOOBPer;
    bounds.pressureOOBPer    = pressureOOBPer;
    bounds.humidityOOBPer    = humidityOOBPer;
    
   % For Latest Ones 
    temperatureOOBIndex = tableInLatest.BME280_temperatureK>120 |tableInLatest.BME280_temperatureK<20;
    pressureOOBIndex    = tableInLatest.BME280_pressureLog>3.01|tableInLatest.BME280_pressureLog<2.98;
    humidityOOBIndex    = tableInLatest.BME280_humidity>100|tableInLatest.BME280_humidity<0;
    temperatureOOB      = sum(temperatureOOBIndex);
    pressureOOB         = sum(pressureOOBIndex);
    humidityOOB         = sum(humidityOOBIndex);
    temperatureOOBPer   = 100*(temperatureOOB/height(tableInLatest));
    pressureOOBPer      = 100*(pressureOOB/height(tableInLatest));
    humidityOOBPer      = 100*(humidityOOB/height(tableInLatest));
    
    
     bounds.temperatureOOBPerLatest  = temperatureOOBPer;
     bounds.pressureOOBPerLatest     = pressureOOBPer;
     bounds.humidityOOBPerLates      = humidityOOBPer;
    
    if(height(tableInWeek)>0)
        temperatureOOBIndex = tableInWeek.BME280_temperatureK>120 |tableInWeek.BME280_temperatureK<20;
        pressureOOBIndex    = tableInWeek.BME280_pressureLog>3.01|tableInWeek.BME280_pressureLog<2.98;
        humidityOOBIndex    = tableInWeek.BME280_humidity>100|tableInWeek.BME280_humidity<0;
        temperatureOOB      = sum(temperatureOOBIndex);
        pressureOOB         = sum(pressureOOBIndex);
        humidityOOB         = sum(humidityOOBIndex);
        temperatureOOBPer   = 100*(temperatureOOB/height(tableInWeek));
        pressureOOBPer      = 100*(pressureOOB/height(tableInWeek));
        humidityOOBPer      = 100*(humidityOOB/height(tableInWeek));
        

        bounds.temperatureOOBPerWeekly = temperatureOOBPer;
        bounds.pressureOOBPerWeekly    = pressureOOBPer;
        bounds.humidityOOBPerWeekly    = humidityOOBPer;
    else
        bounds.temperatureOOBPerWeekly = -1;
        bounds.pressureOOBPerWeekly    = -1;
        bounds.humidityOOBPerWeekly    = -1;
    end
    
    resultsT =  struct2table(bounds)   ;
    display(resultsT)
    % Global CSV  Changed to test CSV
    globalCSV   = modelsMatsFolder +"/"+ ...
        fileName+ ".csv";
    
    folderCheck(globalCSV);
    
    if isfile(globalCSV)
        % File exists.
        writetable(resultsT,globalCSV,"WriteMode","append");
    else
        % File does not exist.
        writetable(resultsT,globalCSV);
    end
    
    display(newline);
    
end

end