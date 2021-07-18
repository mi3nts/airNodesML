function mintsData = getSyncedDataV2(dataFolder,searchPath,nodeID,sensorID,timeSpan)
%GETSYNCEDDATA Summary of this function goes here
%   Detailed explanation goes here
dataFiles =  dir(strcat(dataFolder,searchPath,nodeID,'_',sensorID,'*.csv'));
if length(dataFiles)>0
    mintsData = getSyncedDataV2Sub(dataFiles,sensorID,timeSpan);
else
    mintsData = [];
end
end

