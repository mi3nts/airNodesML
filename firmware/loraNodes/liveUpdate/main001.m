clc
clear all
close all

addpath("../../../functions/")
addpath("../../../functions/ZipLatLon")
addpath("../../../YAMLMatlab_0.4.3")

currentTime = datetime('now');
endTime   =  currentTime +days(1);

while currentTime < endTime
    for n = 1:31
        liveUpdateV2(n)
            pause(5)
    end
    currentTime = datetime('now');
    pause(5)
end

