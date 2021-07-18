function  pmWithTargets  = calibrationsClimateV2(sensorStack,targets)

if cellIncluded("BME280",sensorStack)
    pmWithTargets.BME280_temperatureK =...
                convtemp(pmWithTargets.BME280_temperature ,'C','F');
    pmWithTargets.BME280_pressureLog  = ...
                log10( pmWithTargets.BME280_pressure+1);
    
    [countsTK centersTK] = hist(pmWithTargets.BME280_temperatureK,100);
    [countsPL centersPL] = hist(pmWithTargets.BME280_pressureLog,100);
    [countsH centersH]   = hist(pmWithTargets.BME280_humidity,100);
    
    temperatureKMin = centersTK(1);
    temperatureKMax = centersTK(end);
    pressureLogMin = centersPL(1);
    pressureLogMax = centersPL(end);
    humdityMin = centersH(1);
    humdityMax = centersH(end);

    display("Saving Min Max data for Node: "+nodeID )
    fileNameStr = strcat(minMaxFolder,"/UTDNodes/minMax_", nodeID,".mat");
    
    folderCheck(fileNameStr)
    save(fileNameStr,...
        'temperatureKMin','temperatureKMax',...
        'pressureLogMin','pressureLogMax',...
        'humdityMin','humdityMax'...
        )
end