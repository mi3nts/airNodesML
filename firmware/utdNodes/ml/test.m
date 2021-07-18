
load('test.mat')

eval(strcat("sensorStack              = mintsDefinitions.sensorStack_",string(nodeIDs{nodeIndex}.pmStack),";"))

if cellIncluded("BME280",sensorStack)
    mintsDataUTD.BME280_temperatureK = convtemp(  mintsDataUTD.BME280_temperature ,'C','F');
    mintsDataUTD.BME280_pressureLog  = log(mintsDataUTD.BME280_pressure);

    
end    
    
if cellIncluded("OPCN2",sensorStack)
    mintsDataUTD.OPCN2_bin0Log   = log(mintsDataUTD.OPCN2_binCount0);
    mintsDataUTD.OPCN2_bin1Log   = log(mintsDataUTD.OPCN2_binCount1);
    mintsDataUTD.OPCN2_bin2Log   = log(mintsDataUTD.OPCN2_binCount2);
    mintsDataUTD.OPCN2_bin3Log   = log(mintsDataUTD.OPCN2_binCount3);
    mintsDataUTD.OPCN2_bin4Log   = log(mintsDataUTD.OPCN2_binCount4);
    mintsDataUTD.OPCN2_bin5Log   = log(mintsDataUTD.OPCN2_binCount5);
    mintsDataUTD.OPCN2_bin6Log   = log(mintsDataUTD.OPCN2_binCount6);
    mintsDataUTD.OPCN2_bin7Log   = log(mintsDataUTD.OPCN2_binCount7);
    mintsDataUTD.OPCN2_bin8Log   = log(mintsDataUTD.OPCN2_binCount8);
    mintsDataUTD.OPCN2_bin9Log   = log(mintsDataUTD.OPCN2_binCount9);
    mintsDataUTD.OPCN2_bin10Log  = log(mintsDataUTD.OPCN2_binCount10);
    mintsDataUTD.OPCN2_bin11Log  = log(mintsDataUTD.OPCN2_binCount11);
    mintsDataUTD.OPCN2_bin12Log  = log(mintsDataUTD.OPCN2_binCount12);
    mintsDataUTD.OPCN2_bin13Log  = log(mintsDataUTD.OPCN2_binCount13);
    mintsDataUTD.OPCN2_bin14Log  = log(mintsDataUTD.OPCN2_binCount14);
    mintsDataUTD.OPCN2_bin15Log  = log(mintsDataUTD.OPCN2_binCount15);    
end    

if cellIncluded("OPCN3",sensorStack)
    mintsDataUTD.OPCN3_bin0Log   = log(mintsDataUTD.OPCN3_binCount0);
    mintsDataUTD.OPCN3_bin1Log   = log(mintsDataUTD.OPCN3_binCount1);
    mintsDataUTD.OPCN3_bin2Log   = log(mintsDataUTD.OPCN3_binCount2);
    mintsDataUTD.OPCN3_bin3Log   = log(mintsDataUTD.OPCN3_binCount3);
    mintsDataUTD.OPCN3_bin4Log   = log(mintsDataUTD.OPCN3_binCount4);
    mintsDataUTD.OPCN3_bin5Log   = log(mintsDataUTD.OPCN3_binCount5);
    mintsDataUTD.OPCN3_bin6Log   = log(mintsDataUTD.OPCN3_binCount6);
    mintsDataUTD.OPCN3_bin7Log   = log(mintsDataUTD.OPCN3_binCount7);
    mintsDataUTD.OPCN3_bin8Log   = log(mintsDataUTD.OPCN3_binCount8);
    mintsDataUTD.OPCN3_bin9Log   = log(mintsDataUTD.OPCN3_binCount9);
    mintsDataUTD.OPCN3_bin10Log  = log(mintsDataUTD.OPCN3_binCount10);
    mintsDataUTD.OPCN3_bin11Log  = log(mintsDataUTD.OPCN3_binCount11);
    mintsDataUTD.OPCN3_bin12Log  = log(mintsDataUTD.OPCN3_binCount12);
    mintsDataUTD.OPCN3_bin13Log  = log(mintsDataUTD.OPCN3_binCount13);
    mintsDataUTD.OPCN3_bin14Log  = log(mintsDataUTD.OPCN3_binCount14);
    mintsDataUTD.OPCN3_bin15Log  = log(mintsDataUTD.OPCN3_binCount15);   
    mintsDataUTD.OPCN3_bin16Log  = log(mintsDataUTD.OPCN3_binCount16);
    mintsDataUTD.OPCN3_bin17Log  = log(mintsDataUTD.OPCN3_binCount17);
    mintsDataUTD.OPCN3_bin18Log  = log(mintsDataUTD.OPCN3_binCount18);
    mintsDataUTD.OPCN3_bin19Log  = log(mintsDataUTD.OPCN3_binCount19);
    mintsDataUTD.OPCN3_bin20Log  = log(mintsDataUTD.OPCN3_binCount20);
    mintsDataUTD.OPCN3_bin21Log  = log(mintsDataUTD.OPCN3_binCount21);
    mintsDataUTD.OPCN3_bin22Log  = log(mintsDataUTD.OPCN3_binCount22);
    mintsDataUTD.OPCN3_bin23Log  = log(mintsDataUTD.OPCN3_binCount23);
    
end  


        



