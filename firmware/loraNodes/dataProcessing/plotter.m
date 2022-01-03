
% # ***************************************************************************
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   & 
% #   TRECIS: Texas Research and Education Cyberinfrastructure Services  
% #   ---------------------------------
% #   Date: Dec 21st, 2021
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   ---------------------------------------------------------------------
% #   
% #   MINTS:
% #      https://github.com/mi3nts
% #      http://utdmints.info/
% #   TRECIS
% #      https://trecis.cyberinfrastructure.org/
% #      http://mintswiki.trecis.cloud/
% #   
% #   Contact: 
% #      email: lhw150030@utdallas.edu 
% # ***********************************************************************
% #   Raw to Mat - Concantinates all .csv files from UTD nodes and creates 
% #   a single .mat file for each UTD Node    

clc
clear all
close all

display(newline)
display("---------------------MINTS---------------------")

addpath("../../../YAMLMatlab_0.4.3")
addpath("../../../functions/")
mintsDefinitions  = ReadYaml('../mintsDefinitionsLR.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/rawMqtt";
rawMatsFolder  =  dataFolder + "/rawMats";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)
display(newline)

for nodeIndex = 1: length(nodeIDs)
   
nodeID = nodeIDs{nodeIndex}.nodeID;
stack  = nodeIDs{nodeIndex}.sensorStack;
try
        display(strcat("Loading LoRa Node Data for : ", nodeID));
        loadName  = strcat(rawMatsFolder,'/LoRaNodes/Mints_LoRa_Node_',nodeID,'_',string(timeSpan),'.mat');
        load(loadName)
    catch
mintsDataLR = [];
end


        if height(mintsDataLR)>0
            try
                eval(strcat("fig",string(nodeIndex)," = figure(",string(nodeIndex),")"))
                mintsDataLR.dateTime.TimeZone = 'America/Chicago';
                plot(mintsDataLR.dateTime,mintsDataLR.INA219Duo_busVoltageBattery,'bx')
                hold on 
                plot(mintsDataLR.dateTime,mintsDataLR.INA219Duo_busVoltageSolar,'rx')
                plot(mintsDataLR.dateTime,mintsDataLR.PM_powerMode,'kx')
                plot(mintsDataLR.dateTime,mintsDataLR.IPS7100_pm0_1,'go')
                title(string(nodeIndex) + " NodeID: " + nodeID +" "  + "Stack:" + string(stack) )
                xlabel('Date Time')
                ylabel('Data')
                grid('on')
                legend('Battery Voltage','Solar Voltage', 'PowerMode','PM_{0.5}')
                axis('on')
                hold off 
            catch
              eval(strcat("close(fig",string(nodeIndex),")"))
            end

        end

%   close all  
end