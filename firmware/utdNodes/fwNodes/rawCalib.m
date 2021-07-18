
clc
clear all 
close all 

display(newline)
display("---------------------MINTS---------------------")

addpath("../../../functions/")

hold on addpath("YAMLMatlab_0.4.3")
% mintsDefinitions  = ReadYaml('../mintsDefinitions.yaml')
% 
% nodeID = 

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

load('/home/teamlary/mnt/teamlary1/mintsData/rawMats/UTDNodes/Mints_UTD_Node_001e063239e3.mat')

mintsDataFW =  gpsCropUTD(mintsDataUTD,32.7591540000000,-97.3423320000000,.015,.015);
                 
% https://aqs.epa.gov/data/api/sampleData/bySite?email=lakithaomal@gmail.com&key=ochreram73&param
% =88101&bdate=20160101&edate=20161231&state=48&county=439&site=439                               
                               
% Download Data from EPA Sensors 




