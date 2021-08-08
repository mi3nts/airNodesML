clc
clear all
close all
currentTime = datetime('now');
endTime   =  currentTime +days(1);

while currentTime < endTime
    for n = 1:31
        liveUpdate(n)
    end
    currentTime = datetime('now');
end