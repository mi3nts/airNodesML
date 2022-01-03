clc
clear all
close all



for nodeIndex = 1:31
 
    [daysBackEnd,daysBackStart] = getSummary(nodeIndex);
    
    for daysBack =daysBackEnd:daysBackStart
        dailyUpdateLive(nodeIndex,daysBack)
    end
end