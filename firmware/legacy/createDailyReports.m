clc
clear all
close all

% Import DOM and  Report Libraries
import mlreportgen.dom.*;
import mlreportgen.report.*;

display(newline)
display("---------------------MINTS---------------------")

addpath("../YAMLMatlab_0.4.3")
addpath("../functions/")
mintsDefinitions  = ReadYaml('mintsDefinitions.yaml')

nodeIDs        = mintsDefinitions.nodeIDs;
timeSpan       = seconds(mintsDefinitions.timeSpan);

dataFolder     =  mintsDefinitions.dataFolder;
rawFolder      =  dataFolder + "/raw";
rawMatsFolder  =  dataFolder + "/rawMats";
% matsFolder     =  dataFolder + "/mats";


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawMatsFolder)

display(newline)

doctype = "pdf"
rpt = Report("UTD Nodes",doctype)

%% Cover Page
tp =  TitlePage("Title","UTD Nodes",...
    "SubTitle","Multi-scale Integrated Sensing and Simulation (MINTS)",...
    "Author","Laktha Wijeratne - MINTS",...
    "Image", "utdNode.png"...
    )

add(rpt,tp)

%% Table of Contents

toc = TableOfContents;
add(rpt,toc)

for nodeIndex =1: length(nodeIDs)
    
    nodeID         = nodeIDs{nodeIndex}.nodeID;
    display(strcat("Loading UTD Node Data for : ", nodeID));
    loadName  = strcat(rawMatsFolder,'/UTDNodes/Mints_UTD_Node_',nodeID,'.mat');
    
    if exist(loadName)
        load(loadName);
        mintsDataUTD(mintsDataUTD.dateTime<datetime(2018,1,1,'timezone','utc'),:) = [];
        
        
        %% Creating Chapter for a given Node
        ch = Chapter(strcat("NODE " +nodeID));
        
        % Adding Sections
        if sum(strmatch('OPCN2',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("OPC N2");
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN2_pm1,...
                nodeID,...
                "Date Time","PM_{1}",...
                "PM_{1} Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN2_pm2_5,...
                nodeID,...
                "Date Time","PM_{2.5}",...
                "PM_{2.5} Time Series",...
                5,5)     ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN2_pm10,...
                nodeID,...
                "Date Time","PM_{10}",...
                "PM_{10} Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        % Adding Sections
        if sum(strmatch('OPCN3',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("OPC N3");
            
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN3_pm1,...
                nodeID,...
                "Date Time","PM_{1}",...
                "PM_{1} Time Series",...
                5,5)  ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN3_pm2_5,...
                nodeID,...
                "Date Time","PM_{2.5}",...
                "PM_{2.5} Time Series",...
                5,5)  ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.OPCN3_pm10,...
                nodeID,...
                "Date Time","PM_{10}",...
                "PM_{10} Time Series",...
                5,5)   ;
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        
        
        % Adding Sections
        if sum(strmatch('BME280',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("BME 280")
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.BME280_temperature,...
                nodeID,...
                "Date Time","Temperature",...
                "Temperature Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.BME280_humidity,...
                nodeID,...
                "Date Time","Humidity",...
                "Humidity Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.BME280_pressure,...
                nodeID,...
                "Date Time","Pressure",...
                "Pressure Time Series",...
                5,5)
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        %% Adding Sections
        if sum(strmatch('SCD30',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("SCD 30")
            
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.SCD30_c02,...
                nodeID,...
                "Date Time","Temperature",...
                "Temperature Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.SCD30_temperature,...
                nodeID,...
                "Date Time","Humidity",...
                "Humidity Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.SCD30_humidity,...
                nodeID,...
                "Date Time","Pressure",...
                "Pressure Time Series",...
                5,5)
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        %% Adding Sections
        if sum(strmatch('MGS001',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("MiCS-6814")
            
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_c2h5oh,...
                nodeID,...
                "Date Time","C_{2}H_{5}OH",...
                "C_{2}H_{5}OH Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_c3h8,...
                nodeID,...
                "Date Time","C_{3}H_{8}",...
                "C_{3}H_{8} Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_c4h10,...
                nodeID,...
                "Date Time","C_{4}H_{10}",...
                "C_{4}H_{10} Time Series",...
                5,5)
            add(sc,Figure(fig));
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_ch4,...
                nodeID,...
                "Date Time","CH_{4}",...
                "CH_{4} Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_co,...
                nodeID,...
                "Date Time","CO",...
                "CO Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_h2,...
                nodeID,...
                "Date Time","H_{2}",...
                "H_{2} Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_nh3,...
                nodeID,...
                "Date Time","NH_{3}",...
                "NH_{3} Time Series",...
                5,5)
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.MGS001_no2,...
                nodeID,...
                "Date Time","NO_{2}",...
                "NO_{2} Time Series",...
                5,5)
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        %% Adding Sections
        if sum(strmatch('VEML6075',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("VEML6075")
            
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.VEML6075_uva,...
                nodeID,...
                "Date Time","UVA",...
                "UVA Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.VEML6075_uvb,...
                nodeID,...
                "Date Time","UVB",...
                "UVB Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        %% Adding Sections
        if sum(strmatch('TSL2591',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("TSL2591")
            
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.TSL2591_full,...
                nodeID,...
                "Date Time","Full Light Spectrum",...
                "Full Light Spectrum Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.TSL2591_ir,...
                nodeID,...
                "Date Time","IR",...
                "IR Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.TSL2591_luminosity,...
                nodeID,...
                "Date Time","Luminosity",...
                "Luminosity Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.TSL2591_lux,...
                nodeID,...
                "Date Time","LUX",...
                "LUX Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.TSL2591_visible,...
                nodeID,...
                "Date Time","Visible",...
                "Visible Time Series",...
                5,5) ;
            
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        %% Adding Sections
        if sum(strmatch('AS7262',mintsDataUTD.Properties.VariableNames))>0
            sc = Section("AS7262")
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_blueCalibrated,...
                nodeID,...
                "Date Time","Blue",...
                "Blue Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_greenCalibrated,...
                nodeID,...
                "Date Time","Green",...
                "Green Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_orangeCalibrated,...
                nodeID,...
                "Date Time","Orange",...
                "Orange Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_redCalibrated,...
                nodeID,...
                "Date Time","Red",...
                "Red Time Series",...
                5,5) ;
            add(sc,Figure(fig));
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_violetCalibrated,...
                nodeID,...
                "Date Time","Violet",...
                "Violet Time Series",...
                5,5) ;
            
            add(sc,Figure(fig));
            
            fig =drawTimeSeriesReports(mintsDataUTD.dateTime,...
                mintsDataUTD.AS7262_yellowCalibrated,...
                nodeID,...
                "Date Time","Yellow",...
                "Yellow Time Series",...
                5,5) ;
            
            add(sc,Figure(fig));
            add(ch,sc);
        end
        
        add(rpt,ch)
        delete(gcf);
        
        
    else
        display(strcat("No data for ",nodeID))
    end
    
    clearvars -except dataFolder rawMatsFolder ...
        nodeIDs timeSpan rpt...
        nodeIndex mintsDefinitions
    
end

close(rpt);
rptview(rpt);
