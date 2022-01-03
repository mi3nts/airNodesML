
clc
clear all 
close all 

display(newline)
display("---------------------MINTS---------------------")

addpath("../../../functions/")
addpath("YAMLMatlab_0.4.3")

%% Epa Data Downlaod
epaPM2_5_2020= epaDownload("88101",...
               "20200101","20201231",...
                  "48","439","1006",...
                     "lakithaomal@gmail.com","ochreram73");

epaPM2_5_2021= epaDownload("88101",...
               "20210101","20211231",...
                  "48","439","1006",...
                     "lakithaomal@gmail.com","ochreram73");          
                 
epaPM2_5 =   [epaPM2_5_2020;epaPM2_5_2021]  ;


load('/home/teamlary/mnt/teamlary1/mintsData/liveUpdate/UTDNodes/001e063239e3/summary/Mints_001e063239e3_Raw.mat')

mintsDataFW1 = gpsCoordAdder(...
        inCorrected,...
        datetime(2020,06,05,'timezone','utc'),...
        datetime(2021,05,04,'timezone','utc'),...
        32.759154,...
        -97.342332,...
        167.6136);

mintsDataFW1 =  gpsCropUTD(mintsDataFW1,32.7591540000000,-97.3423320000000,.015,.015); 
mintsDataFW1 =  retime(mintsDataFW1,'regular',@nanmean,'TimeStep',hours(1));


load('/home/teamlary/mnt/teamlary1/mintsData/liveUpdate/UTDNodes/001e06305a57/summary/Mints_001e06305a57_Raw.mat')
mintsDataFW2 = gpsCoordAdder(...
        inCorrected,...
        datetime(2021,05,06,'timezone','utc'),...
        datetime(2021,12,31,'timezone','utc'),...
        32.759154,...
        -97.342332,...
        167.6136);
    
mintsDataFW2 =  gpsCropUTD(mintsDataFW2,32.7591540000000,-97.3423320000000,.015,.015);    
mintsDataFW2   =  retime(mintsDataFW2,'regular',@nanmean,'TimeStep',hours(1));

%% Plotting 

plot(epaPM2_5.dateTime,epaPM2_5.pm2_5_bam,'r')
hold on 
plot(mintsDataFW1.dateTime,mintsDataFW1.pm2_5_palas_predicted,'b')
plot(mintsDataFW2.dateTime,mintsDataFW2.pm2_5_palas_predicted,'g')










