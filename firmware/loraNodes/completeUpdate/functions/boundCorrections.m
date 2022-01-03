    
function inCorrected = boundCorrections(inCorrected,climateParamsNow)
    
    inCorrected(inCorrected.dateTime<datetime(2019,1,1,'timezone','utc'),:)=[];

    if sum(contains(inCorrected.Properties.VariableNames,"BME280"))>0
            inCorrected.BME280_temperatureK(...
                inCorrected.BME280_temperatureK<climateParamsNow.minTemperatureK,:)...
                    = climateParamsNow.minTemperatureK;

            inCorrected.BME280_temperatureK(...
                inCorrected.BME280_temperatureK>climateParamsNow.maxTemperatureK,:)...
                    = climateParamsNow.maxTemperatureK;

            inCorrected.BME280_minPressureLog(...
                inCorrected.BME280_pressureLog<climateParamsNow.minPressureLog,:)...
                    = climateParamsNow.minPressureLog;

            inCorrected.BME280_pressureLog(...
                inCorrected.BME280_pressureLog>climateParamsNow.maxPressureLog,:)...
                    = climateParamsNow.maxPressureLog;   

            inCorrected.BME280_temperatureK(...
                inCorrected.BME280_humidity<climateParamsNow.minHumidity,:)...
                    = climateParamsNow.minHumidity;   

            inCorrected.BME280_temperatureK(...
                inCorrected.BME280_humidity>climateParamsNow.maxHumidity,:)...
                    = climateParamsNow.maxHumidity;        
    end 