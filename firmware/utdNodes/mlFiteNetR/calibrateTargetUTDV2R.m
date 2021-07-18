function Mdl= calibrateTargetUTDV2R(...
                            isPoly,climateParams,...
                            targets,targetIndex,targetLabels,...
                            nodeID,inputs,inputLabels,pValid,...
                            withTargets,...
                            binsPerColumn,numberPerBin,...
                            instruments,units,limitsLow,limitsHigh,...
                            plotsFolder,dailyString,versionStr,...
                            graphTitle1,modelsMatsFolder,...
                            globalCSVLabel,trainingMatsFolder,testingVariables)

target = targets{targetIndex};
targetLabel = targetLabels{targetIndex};
display(newline)
display("Gainin Data set for Node "+ nodeID + " with target output " + target +" @ "+ datestr(datetime('now')) )
[In_Train,Out_Train,...
            In_Validation,Out_Validation,...
               trainingTT, validatingTT,...
                trainingT, validatingT,...
                In_Train_Testing ,Out_Train_Testing ,...
                In_Validation_Testing ,Out_Validation_Testing ,...
                trainingTT_Testing , validatingTT_Testing ,...
                    trainingT_Testing , validatingT_Testing ...
                                ]...
    = representativeSampleTTR(withTargets,inputs,target,pValid,binsPerColumn,numberPerBin,testingVariables);

display("Running Regression")

if isPoly
% Calibrate Climate 
Mdl  = polyfit(In_Train,Out_Train,1);
outTrainEstimate= polyval(Mdl,In_Train);
outValidEstimate= polyval(Mdl,In_Validation);
else
display("Training")
Mdl  = fitRNetOptimized(In_Train,Out_Train);
display("Trained")
outTrainEstimateR= predict(Mdl,In_Train);
outValidEstimateR= predict(Mdl,In_Validation);

outTrainEstimate= predict(Mdl,In_Train_Testing);
outValidEstimate= predict(Mdl,In_Validation_Testing);

end

instrument = instruments{targetIndex}


resultsCurrent = plottingAllGraphsV2(plotsFolder,nodeID,target,...
                            dailyString,versionStr,...
                            outTrainEstimate,outValidEstimate,...
                            trainingTT,validatingTT,...
                            Out_Train,Out_Validation,...
                            units,targetLabel,...
                            limitsLow,limitsHigh,...
                            targetIndex,graphTitle1,...
                            instrument)

% %% Get Statistics
% display(newline);
% combinedFigDaily   = getFileNameFigure(plotsFolder,nodeID,target,dailyString)
% folderCheck(combinedFigDaily)
% 
% combinedFig        = strrep(combinedFigDaily,dailyString,strcat(versionStr,"/",versionStr));
% folderCheck(combinedFig)
% 
% % Adding a Time Series Plot (02,21,2021)
% combinedFigTT        = strrep(combinedFig,".png",...
%     "_TT.png")
% 
% drawTimeSeries3x(trainingTT.dateTime,outTrainEstimate,...
%     validatingTT.dateTime,outValidEstimate,...
%     [trainingTT.dateTime;validatingTT.dateTime],...
%     [Out_Train;Out_Validation],...
%     "Training Estimates","Testing Estimates ",instrument,...
%     nodeID,"Date Time (UTC)",...
%     targetLabel +" ("+ units{targetIndex}+ ")",...
%     targetLabel + " Calibration ("+strrep(versionStr,"_"," ")+")",...
%     combinedFigTT)
% 
% graphTitle2 = strcat(" ");
% 
% drawScatterPlotMintsCombinedLimitsUTD(Out_Train,...
%     outTrainEstimate,...
%     Out_Validation,...
%     outValidEstimate,...
%     limitsLow{targetIndex},...
%     limitsHigh{targetIndex},...
%     nodeID,...
%     targetLabel,...
%     instrument,...
%     "UTD Node",...
%     units{targetIndex},...
%     combinedFigDaily,...
%     graphTitle1,...
%     graphTitle2);
% 
% resultsCurrent=drawScatterPlotMintsCombinedLimitsUTD(Out_Train,...
%     outTrainEstimate,...
%     Out_Validation,...
%     outValidEstimate,...
%     limitsLow{targetIndex},...
%     limitsHigh{targetIndex},...
%     nodeID,...
%     targetLabel,...
%     instrument,...
%     "UTD Node",...
%     units{targetIndex},...
%     combinedFig,...
%     graphTitle1,...
%     graphTitle2);

%% Saving Model Files
display(strcat("Saving Model Files for Node: ",string(nodeID), " & target :" ,targetLabel));
modelsSaveNameDaily = getMintsNameGeneral(modelsMatsFolder,nodeID,...
    target,"daily_Mdl")
folderCheck(modelsSaveNameDaily)

modelsSaveName      = strrep(modelsSaveNameDaily,"daily_Mdl",strcat(versionStr,"/",versionStr))
resultsSaveName     = strrep(modelsSaveNameDaily,".mat",".csv")

folderCheck(modelsSaveName)

save(modelsSaveName,'Mdl',...
    'isPoly',...
    'climateParams',...
    'inputs',...
    'inputLabels',...
    'target',...
    'targetLabel',...
    'resultsCurrent'...
    )

save(modelsSaveNameDaily,'Mdl',...
    'isPoly',...
    'climateParams',...
    'inputs',...
    'inputLabels',...
    'target',...
    'targetLabel',...
    'resultsCurrent'...
    )

display(newline);

 saveResultsV2(resultsCurrent,versionStr,...
                resultsSaveName,modelsMatsFolder,globalCSVLabel,...
                pValid,nodeID,target,binsPerColumn,numberPerBin,...
                trainingTT,validatingTT)


            
                       
% %% Additional parametors to keep
% resultsCurrent.pValid             = pValid;
% resultsCurrent.nodeID             = nodeID;
% resultsCurrent.target             = target;
% resultsCurrent.binsPerColumn      = binsPerColumn;
% resultsCurrent.numberPerBin       = numberPerBin;
% resultsCurrent.trainRows          = height(trainingTT);
% resultsCurrent.validRows          = height(validatingTT);
% 
% resultsCurrent.versionStr = versionStr;
% 
% resultsT =  struct2table(resultsCurrent)   ;
% 
% if isfile(resultsSaveName)
%     % File exists.
%     writetable(resultsT,resultsSaveName,"WriteMode","append");
% else
%     % File does not exist.
%     writetable(resultsT,resultsSaveName);
% end
% 
% 
% 
% 
% % Global CSV  Changed to test CSV
% globalCSV   = modelsMatsFolder +"/"+globalCSVLabel + ...
%     ".csv";
% 
% if isfile(globalCSV)
%     % File exists.
%     writetable(resultsT,globalCSV,"WriteMode","append");
% else
%     % File does not exist.
%     writetable(resultsT,globalCSV);
% end

display(newline);

%% Saving Training Data
trainingSaveNameDaily = getMintsNameGeneral(trainingMatsFolder,nodeID,...
    target,dailyString)
folderCheck(trainingSaveNameDaily)

trainingSaveName      = strrep(trainingSaveNameDaily,dailyString,strcat(versionStr,"/",versionStr))
folderCheck(trainingSaveName)

save(trainingSaveNameDaily,...
    'Mdl',...
    'isPoly',...
    'climateParams',...
    'In_Train',...
    'Out_Train',...
    'In_Validation',...
    'Out_Validation',...
    'trainingTT',...
    'validatingTT',...
    'trainingT',...
    'validatingT',...
    'inputs',...
    'inputLabels',...
    'target',...
    'targetLabel',...
    'nodeID',...
    'binsPerColumn',...
    'numberPerBin',...
    'pValid', ...
    'resultsCurrent'...
    )

save(trainingSaveName,...
    'Mdl',...
    'isPoly',...
    'climateParams',...
    'In_Train',...
    'Out_Train',...
    'In_Validation',...
    'Out_Validation',...
    'trainingTT',...
    'validatingTT',...
    'trainingT',...
    'validatingT',...
    'inputs',...
    'inputLabels',...
    'target',...
    'targetLabel',...
    'nodeID',...
    'binsPerColumn',...
    'numberPerBin',...
    'pValid' ,...
    'resultsCurrent'...
    )


resultsCurrentR = plottingAllGraphsV2(plotsFolder,nodeID,target,...
                            strcat(dailyString,"_R"),versionStr,...
                            outTrainEstimateR,outValidEstimateR,...
                            trainingTT_Testing,validatingTT_Testing,...
                            Out_Train_Testing,Out_Validation_Testing,...
                            units,targetLabel,...
                            limitsLow,limitsHigh,...
                            targetIndex,graphTitle1,...
                            instrument)

                        
resultsSaveName     = strrep(modelsSaveNameDaily,".mat","_R.csv")                        
% saveResultsV2(resultsCurrentR,versionStr,...
%                 resultsSaveName,modelsMatsFolder,strcat(globalCSVLabel,"_R"))
saveResultsV2(resultsCurrent,versionStr,...
                resultsSaveName,modelsMatsFolder,strcat(globalCSVLabel,"_R"),...
                pValid,nodeID,target,binsPerColumn,numberPerBin,...
                trainingTT,validatingTT)
% %% Saving the Structure File
% clearvars -except...
%     graphTitle1...
%     versionStrTrain versionStrMdl dailyString dailyStringImp ...
%     plotsFolder limitsLow limitsHigh units instruments....
%     palasWithAirmar deployments ...
%     nodeIDs nodeID utdWithTargets UTDMatsFolder...
%     versionStrTrain versionStrMdl ...
%     rawMatsFolder mergedMatsFolder ...
%     trainingMatsFolder modelsMatsFolder...
%     nodeIDs nodeIndex nodeID ...
%     mintsInputs mintsInputLabels ...
%     mintsTargets mintsTargetLabels targetIndex ...
%     binsPerColumn numberPerBin pValid  ...
%     mintsDefinitions results resultsFolder ...
%     resultsGlobal resultsCurrent globalCSVLabel...
%     climateModels
close all
end %Targets
