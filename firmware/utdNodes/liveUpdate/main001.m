clc
clear all
close all
clc
clear all
close all

addpath("../../../functions/")
addpath("../../../functions/ZipLatLon")
addpath("../../../YAMLMatlab_0.4.3")

currentTime = datetime('now');
endTime   =  currentTime +days(1);

while currentTime < endTime
    %for n = 1:21
    pause(10)    
    liveUpdate(3)
    pause(10)
        liveUpdate(4)
	pause(10)
        liveUpdate(6)
	pause(10)
        liveUpdate(11)
	pause(10)
        liveUpdate(12)
	pause(10)
        liveUpdate(13)
	pause(10)
        liveUpdate(21)

    %end
    currentTime = datetime('now');
end

