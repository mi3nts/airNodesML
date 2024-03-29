
clc
clear all
close all

mintsDataJuly01 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_01.csv");
mintsDataJuly02 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_02.csv");
mintsDataJuly03 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_03.csv");
mintsDataJuly04 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_04.csv");
mintsDataJuly05 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_05.csv");
mintsDataJuly06 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_06.csv");
mintsDataJuly07 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_07.csv");
mintsDataJuly08 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_08.csv");
mintsDataJuly09 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_09.csv");
mintsDataJuly10 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_10.csv");
mintsDataJuly11 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_11.csv");
mintsDataJuly12 =  importResultsFile(...
    "/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/MINTS_001e06318cee_calibrated_2021_07_12.csv");

mintsData = [...
    mintsDataJuly01;...
    mintsDataJuly02;...
    mintsDataJuly03;...
    mintsDataJuly04;...
    mintsDataJuly05;...
    mintsDataJuly06;...
    mintsDataJuly07;...
    mintsDataJuly08;...
    mintsDataJuly09;...
    mintsDataJuly10;...
    mintsDataJuly11;...
    mintsDataJuly12;...
    ];

load("/home/teamlary/mnt/teamlary1/mintsData/laryTempResults/diagnosis/Eastfeild.mat")
inCorrected(inCorrected.dateTime<datetime(2021,07,01,'timezone','utc'),:)=[];
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','on'...
    );
subplot(2,1,1)
plot(mintsData.dateTime,mintsData.PM2_5)
ylabel("PM_{2.5} (\mug/m^{3})",'FontWeight','bold','FontSize',10);
xlabel("UTC Time",'FontWeight','bold','FontSize',10);
title("Easfeild MINTS Node - PM_{2.5} Readings")

subplot(2,1,2)
plot(inCorrected.dateTime,inCorrected.SCD30_c02)
ylabel("CO_{2} (ppm)",'FontWeight','bold','FontSize',10);
xlabel("UTC Time",'FontWeight','bold','FontSize',10);
title("Easfeild MINTS Node - SCD30 Readings")

    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','on'...
    );
plot(inCorrected.dateTime,inCorrected.pm2_5_palas_predicted)
ylabel("PM_{2.5} (\mug/m^{3})",'FontWeight','bold','FontSize',10);
xlabel("UTC Time",'FontWeight','bold','FontSize',10);
title("Easfeild MINTS Node - Corrected PM_{2.5} Readings")