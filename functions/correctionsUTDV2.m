function  tableIn  = correctionsUTDV2(tableIn)


if sum(contains(tableIn.Properties.VariableNames,"BME280"))>0
    tableIn.BME280_temperatureK =...
                convtemp(tableIn.BME280_temperature ,'C','F');
    tableIn.BME280_pressureLog  = ...
                log10(tableIn.BME280_pressure/100);
end

if sum(contains(tableIn.Properties.VariableNames,"OPCN2"))>0
    tableIn(tableIn.OPCN2_pm1>1000,:) = [] ;
    tableIn.OPCN2_binCount0Log   = log10( tableIn.OPCN2_binCount0+1);
    tableIn.OPCN2_binCount1Log   = log10( tableIn.OPCN2_binCount1+1);
    tableIn.OPCN2_binCount2Log   = log10( tableIn.OPCN2_binCount2+1);
    tableIn.OPCN2_binCount3Log   = log10( tableIn.OPCN2_binCount3+1);
    tableIn.OPCN2_binCount4Log   = log10( tableIn.OPCN2_binCount4+1);
    tableIn.OPCN2_binCount5Log   = log10( tableIn.OPCN2_binCount5+1);
    tableIn.OPCN2_binCount6Log   = log10( tableIn.OPCN2_binCount6+1);
    tableIn.OPCN2_binCount7Log   = log10( tableIn.OPCN2_binCount7+1);
    tableIn.OPCN2_binCount8Log   = log10( tableIn.OPCN2_binCount8+1);
    tableIn.OPCN2_binCount9Log   = log10( tableIn.OPCN2_binCount9+1);
    tableIn.OPCN2_binCount10Log  = log10( tableIn.OPCN2_binCount10+1);
    tableIn.OPCN2_binCount11Log  = log10( tableIn.OPCN2_binCount11+1);
    tableIn.OPCN2_binCount12Log  = log10( tableIn.OPCN2_binCount12+1);
    tableIn.OPCN2_binCount13Log  = log10( tableIn.OPCN2_binCount13+1);
    tableIn.OPCN2_binCount14Log  = log10( tableIn.OPCN2_binCount14+1);
    tableIn.OPCN2_binCount15Log  = log10( tableIn.OPCN2_binCount15+1);
end

if  sum(contains(tableIn.Properties.VariableNames,"OPCN3"))>0
    tableIn(tableIn.OPCN3_pm2_5>1000,:) = [] ;
    tableIn.OPCN3_binCount0Log   = log10( tableIn.OPCN3_binCount0+1);
    tableIn.OPCN3_binCount1Log   = log10( tableIn.OPCN3_binCount1+1);
    tableIn.OPCN3_binCount2Log   = log10( tableIn.OPCN3_binCount2+1);
    tableIn.OPCN3_binCount3Log   = log10( tableIn.OPCN3_binCount3+1);
    tableIn.OPCN3_binCount4Log   = log10( tableIn.OPCN3_binCount4+1);
    tableIn.OPCN3_binCount5Log   = log10( tableIn.OPCN3_binCount5+1);
    tableIn.OPCN3_binCount6Log   = log10( tableIn.OPCN3_binCount6+1);
    tableIn.OPCN3_binCount7Log   = log10( tableIn.OPCN3_binCount7+1);
    tableIn.OPCN3_binCount8Log   = log10( tableIn.OPCN3_binCount8+1);
    tableIn.OPCN3_binCount9Log   = log10( tableIn.OPCN3_binCount9+1);
    tableIn.OPCN3_binCount10Log  = log10( tableIn.OPCN3_binCount10+1);
    tableIn.OPCN3_binCount11Log  = log10( tableIn.OPCN3_binCount11+1);
    tableIn.OPCN3_binCount12Log  = log10( tableIn.OPCN3_binCount12+1);
    tableIn.OPCN3_binCount13Log  = log10( tableIn.OPCN3_binCount13+1);
    tableIn.OPCN3_binCount14Log  = log10( tableIn.OPCN3_binCount14+1);
    tableIn.OPCN3_binCount15Log  = log10( tableIn.OPCN3_binCount15+1);
    tableIn.OPCN3_binCount16Log  = log10( tableIn.OPCN3_binCount16+1);
    tableIn.OPCN3_binCount17Log  = log10( tableIn.OPCN3_binCount17+1);
    tableIn.OPCN3_binCount18Log  = log10( tableIn.OPCN3_binCount18+1);
    tableIn.OPCN3_binCount19Log  = log10( tableIn.OPCN3_binCount19+1);
    tableIn.OPCN3_binCount20Log  = log10( tableIn.OPCN3_binCount20+1);
    tableIn.OPCN3_binCount21Log  = log10( tableIn.OPCN3_binCount21+1);
    tableIn.OPCN3_binCount22Log  = log10( tableIn.OPCN3_binCount22+1);
    tableIn.OPCN3_binCount23Log  = log10( tableIn.OPCN3_binCount23+1);
    
end

end



