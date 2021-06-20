function mintsData = getSyncedDataV2(dataFolder,searchPath,nodeID,sensorID,timeSpan)
%GETSYNCEDDATA Summary of this function goes here
%   Detailed explanation goes here
dataFiles =  dir(strcat(dataFolder,searchPath,nodeID,'_',sensorID,'*.csv'));
if length(dataFiles)>0
    if(sensorID == "GPSGPGGA2")
        mintsData = rmmissing(sensorReadFastV2(dataFiles,@GPGGAReadFast,timeSpan,sensorID));
    elseif (sensorID == "GPSGPRMC2")
        mintsData = rmmissing(sensorReadFastV2(dataFiles,@GPRMCReadFast,timeSpan,sensorID));
    else
        mintsData = rmmissing(sensorReadFastV2(dataFiles,@readFast,timeSpan,sensorID));
    end
    mintsData.Properties.VariableNames = strcat(sensorID,"_", mintsData.Properties.VariableNames);
else
    mintsData = [];
end
end

