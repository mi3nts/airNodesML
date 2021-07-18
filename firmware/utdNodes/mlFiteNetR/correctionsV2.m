function  pmWithTargets  = correctionsV2(sensorStack,nodeID,...
    pmWithTargets,minMaxFolder)



if cellIncluded("BME280",sensorStack)
    pmWithTargets.BME280_temperatureK =...
                convtemp(   pmWithTargets.BME280_temperature ,'C','F');
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

if cellIncluded("OPCN2",sensorStack)
    pmWithTargets(pmWithTargets.OPCN2_pm1>1000,:) = [] ;
    pmWithTargets.OPCN2_binCount0Log   = log10( pmWithTargets.OPCN2_binCount0+1);
    pmWithTargets.OPCN2_binCount1Log   = log10( pmWithTargets.OPCN2_binCount1+1);
    pmWithTargets.OPCN2_binCount2Log   = log10( pmWithTargets.OPCN2_binCount2+1);
    pmWithTargets.OPCN2_binCount3Log   = log10( pmWithTargets.OPCN2_binCount3+1);
    pmWithTargets.OPCN2_binCount4Log   = log10( pmWithTargets.OPCN2_binCount4+1);
    pmWithTargets.OPCN2_binCount5Log   = log10( pmWithTargets.OPCN2_binCount5+1);
    pmWithTargets.OPCN2_binCount6Log   = log10( pmWithTargets.OPCN2_binCount6+1);
    pmWithTargets.OPCN2_binCount7Log   = log10( pmWithTargets.OPCN2_binCount7+1);
    pmWithTargets.OPCN2_binCount8Log   = log10( pmWithTargets.OPCN2_binCount8+1);
    pmWithTargets.OPCN2_binCount9Log   = log10( pmWithTargets.OPCN2_binCount9+1);
    pmWithTargets.OPCN2_binCount10Log  = log10( pmWithTargets.OPCN2_binCount10+1);
    pmWithTargets.OPCN2_binCount11Log  = log10( pmWithTargets.OPCN2_binCount11+1);
    pmWithTargets.OPCN2_binCount12Log  = log10( pmWithTargets.OPCN2_binCount12+1);
    pmWithTargets.OPCN2_binCount13Log  = log10( pmWithTargets.OPCN2_binCount13+1);
    pmWithTargets.OPCN2_binCount14Log  = log10( pmWithTargets.OPCN2_binCount14+1);
    pmWithTargets.OPCN2_binCount15Log  = log10( pmWithTargets.OPCN2_binCount15+1);
end

if cellIncluded("OPCN3",sensorStack)
    pmWithTargets(pmWithTargets.OPCN3_pm2_5>1000,:) = [] ;
    pmWithTargets.OPCN3_binCount0Log   = log10( pmWithTargets.OPCN3_binCount0+1);
    pmWithTargets.OPCN3_binCount1Log   = log10( pmWithTargets.OPCN3_binCount1+1);
    pmWithTargets.OPCN3_binCount2Log   = log10( pmWithTargets.OPCN3_binCount2+1);
    pmWithTargets.OPCN3_binCount3Log   = log10( pmWithTargets.OPCN3_binCount3+1);
    pmWithTargets.OPCN3_binCount4Log   = log10( pmWithTargets.OPCN3_binCount4+1);
    pmWithTargets.OPCN3_binCount5Log   = log10( pmWithTargets.OPCN3_binCount5+1);
    pmWithTargets.OPCN3_binCount6Log   = log10( pmWithTargets.OPCN3_binCount6+1);
    pmWithTargets.OPCN3_binCount7Log   = log10( pmWithTargets.OPCN3_binCount7+1);
    pmWithTargets.OPCN3_binCount8Log   = log10( pmWithTargets.OPCN3_binCount8+1);
    pmWithTargets.OPCN3_binCount9Log   = log10( pmWithTargets.OPCN3_binCount9+1);
    pmWithTargets.OPCN3_binCount10Log  = log10( pmWithTargets.OPCN3_binCount10+1);
    pmWithTargets.OPCN3_binCount11Log  = log10( pmWithTargets.OPCN3_binCount11+1);
    pmWithTargets.OPCN3_binCount12Log  = log10( pmWithTargets.OPCN3_binCount12+1);
    pmWithTargets.OPCN3_binCount13Log  = log10( pmWithTargets.OPCN3_binCount13+1);
    pmWithTargets.OPCN3_binCount14Log  = log10( pmWithTargets.OPCN3_binCount14+1);
    pmWithTargets.OPCN3_binCount15Log  = log10( pmWithTargets.OPCN3_binCount15+1);
    pmWithTargets.OPCN3_binCount16Log  = log10( pmWithTargets.OPCN3_binCount16+1);
    pmWithTargets.OPCN3_binCount17Log  = log10( pmWithTargets.OPCN3_binCount17+1);
    pmWithTargets.OPCN3_binCount18Log  = log10( pmWithTargets.OPCN3_binCount18+1);
    pmWithTargets.OPCN3_binCount19Log  = log10( pmWithTargets.OPCN3_binCount19+1);
    pmWithTargets.OPCN3_binCount20Log  = log10( pmWithTargets.OPCN3_binCount20+1);
    pmWithTargets.OPCN3_binCount21Log  = log10( pmWithTargets.OPCN3_binCount21+1);
    pmWithTargets.OPCN3_binCount22Log  = log10( pmWithTargets.OPCN3_binCount22+1);
    pmWithTargets.OPCN3_binCount23Log  = log10( pmWithTargets.OPCN3_binCount23+1);
    
end

end



