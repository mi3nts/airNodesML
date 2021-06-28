function mintsData = getSyncedDataV2Sub(dataFiles,sensorID,timeSpan)
    try
        if(sensorID == "GPSGPGGA2")
            mintsData = rmmissing(sensorReadFastV2(dataFiles,@GPGGAReadFast,timeSpan,sensorID));
        elseif (sensorID == "GPSGPRMC2")
            mintsData = rmmissing(sensorReadFastV2(dataFiles,@GPRMCReadFast,timeSpan,sensorID));
        else
            mintsData = rmmissing(sensorReadFastV2(dataFiles,@readFast,timeSpan,sensorID));
        end
        mintsData.Properties.VariableNames = strcat(sensorID,"_", mintsData.Properties.VariableNames);
    catch e
        close all
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end 
        

end