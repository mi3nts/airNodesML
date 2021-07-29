
maxTemperatureK = climateParams{1}.maxTemperatureK;
minTemperatureK = climateParams{1}.minTemperatureK ;
maxPressureLog = climateParams{1}.maxPressureLog;
minPressureLog = climateParams{1}.minPressureLog ;
maxHumidity    = climateParams{1}.maxHumidity;
minHumidity    = climateParams{1}.minHumidity ;


for n = 1:length(bestModels)
    n
    maxTemperatureK =   max(maxTemperatureK,climateParams{n}.maxTemperatureK)
    minTemperatureK =   min(minTemperatureK,climateParams{n}.minTemperatureK)   
    maxPressureLog =   max(maxPressureLog,climateParams{n}.maxPressureLog)
    minPressureLog =   min(minPressureLog,climateParams{n}.minPressureLog)   
    maxHumidity  =   max(maxHumidity ,climateParams{n}.maxHumidity )
    minHumidity  =   min(minHumidity ,climateParams{n}.minHumidity )   
    
end 
     