function [BME280,GPSGPGGA2,GPSGPRMC2,MGS001,OPCN2,OPCN3,PPD42NSDuo,SCD30]...
                        = pmInputDataParFor(BME280Files,GPSGPGGA2Files,GPSGPRMC2Files,...
                                MGS001Files,OPCN2Files,OPCN3Files,PPD42NSDuoFiles,SCD30Files,...
                                    readFast,GPGGAReadFast,GPGRMCReadFast,...
                                        timeSpan)

    parfor K = 1 : 8
      if K == 1; mintsData{K}       = sensorReadSolo(BME280Files,@readFast,timeSpan); end
      if K == 2;  mintsData{K}    = sensorReadSolo(GPSGPGGA2Files,@GPGGAReadFast,timeSpan); end
      if K == 3; mintsData{K}    = sensorReadSolo(GPSGPRMC2Files,@GPGRMCReadFast,timeSpan); end
      if K == 4; mintsData{K}       = sensorReadSolo(MGS001Files,@readFast,timeSpan); end
      if K == 5; mintsData{K}        = sensorReadSolo(OPCN2Files,@readFast,timeSpan); end
      if K == 6; mintsData{K}        = sensorReadSolo(OPCN3Files,@readFast,timeSpan); end
      if K == 7; mintsData{K}   = sensorReadSolo(PPD42NSDuoFiles,@readFast,timeSpan); end
      if K == 8; mintsData{K}        = sensorReadSolo(SCD30Files,@readFast,timeSpan); end
    end 
    
    BME280    =  mintsData{1};
    GPSGPGGA2 =  mintsData{2};
    GPSGPRMC2 =  mintsData{3};
    MGS001=  mintsData{4};
    OPCN2 =  mintsData{5};
    OPCN3 =  mintsData{6};
    PPD42NSDuo =  mintsData{7};
    SCD30 =  mintsData{8};
    
end

