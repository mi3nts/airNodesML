function Mdl= calibratePMTargetUTD(...
                            weights,subWeights,...
                            climateTargets,targetIndex,climateTargetLabels,...
                            nodeID,climateInputs,climateInputLabels,pValid,...
                            climateWithTargets,...
                            binsPerColumn,numberPerBin,...
                            instrument,units,limitsLow,limitsHigh,...
                            plotsFolder,dailyString,versionStr,...
                            graphTitle1,modelsMatsFolder,...
                            globalCSVLabel,trainingMatsFolder)

target = climateTargets{targetIndex};
targetLabel = climateTargetLabels{targetIndex};
display(newline)
display("Gainin Data set for Node "+ nodeID + " with target output " + target +" @ "+ datestr(datetime('now')) )
[In_Train,Out_Train,...
    In_Validation,Out_Validation,...
    trainingTT, validatingTT,...
    trainingT, validatingT ] ...
    = representativeSampleTT(climateWithTargets,climateInputs,target,pValid,binsPerColumn,numberPerBin);

display("Running Regression")

% Weighted Adjustment
currentSub     = cell2mat(subWeights);;
In_Train      = In_Train.* cell2mat(weights).*currentSub(targetIndex,:);
In_Validation = In_Validation.* cell2mat(weights).*currentSub(targetIndex,:);

tic
Mdl = fitrnn(In_Train,Out_Train);
toc

%% Estimating Statistics
outTrainEstimate= predictrnn(Mdl,In_Train);
outValidEstimate= predictrnn(Mdl,In_Validation);

%% Get Statistics
display(newline);
combinedFigDaily   = getFileNameFigure(plotsFolder,nodeID,target,dailyString)
folderCheck(combinedFigDaily)

combinedFig        = strrep(combinedFigDaily,dailyString,strcat(versionStr,"/",versionStr));
folderCheck(combinedFig)

% Adding a Time Series Plot (02,21,2021)
combinedFigTT        = strrep(combinedFig,".png",...
    "_TT.png")

drawTimeSeries3x(trainingTT.dateTime,outTrainEstimate,...
    validatingTT.dateTime,outValidEstimate,...
    [trainingTT.dateTime;validatingTT.dateTime],...
    [Out_Train;Out_Validation],...
    "Training Estimates","Testing Estimates ",instrument,...
    nodeID,"Date Time (UTC)",...
    targetLabel +" ("+ units{targetIndex}+ ")",...
    targetLabel + " Calibration ("+strrep(versionStr,"_"," ")+")",...
    combinedFigTT)

graphTitle2 = strcat(" ");

drawScatterPlotMintsCombinedLimitsUTD(Out_Train,...
    outTrainEstimate,...
    Out_Validation,...
    outValidEstimate,...
    limitsLow{targetIndex},...
    limitsHigh{targetIndex},...
    nodeID,...
    targetLabel,...
    instrument,...
    "UTD Node",...
    units{targetIndex},...
    combinedFigDaily,...
    graphTitle1,...
    graphTitle2);

resultsCurrent=drawScatterPlotMintsCombinedLimitsUTD(Out_Train,...
    outTrainEstimate,...
    Out_Validation,...
    outValidEstimate,...
    limitsLow{targetIndex},...
    limitsHigh{targetIndex},...
    nodeID,...
    targetLabel,...
    instrument,...
    "UTD Node",...
    units{targetIndex},...
    combinedFig,...
    graphTitle1,...
    graphTitle2);

%% Saving Model Files
display(strcat("Saving Model Files for Node: ",string(nodeID), " & target :" ,targetLabel));
modelsSaveNameDaily = getMintsNameGeneral(modelsMatsFolder,nodeID,...
    target,"daily_Mdl")
folderCheck(modelsSaveNameDaily)

modelsSaveName      = strrep(modelsSaveNameDaily,"daily_Mdl",strcat(versionStr,"/",versionStr))
resultsSaveName     = strrep(modelsSaveNameDaily,".mat",".csv")

folderCheck(modelsSaveName)

save(modelsSaveName,'Mdl',...
    'climateInputs',...
    'climateInputLabels',...
    'target',...
    'targetLabel',...
    'resultsCurrent'...
    )

save(modelsSaveNameDaily,'Mdl',...
    'climateInputs',...
    'climateInputLabels',...
    'target',...
    'targetLabel',...
    'resultsCurrent'...
    )

display(newline);

%% Additional parametors to keep
resultsCurrent.pValid             = pValid;
resultsCurrent.nodeID             = nodeID;
resultsCurrent.target             = target;
resultsCurrent.binsPerColumn      = binsPerColumn;
resultsCurrent.numberPerBin       = numberPerBin;
resultsCurrent.trainRows          = height(trainingTT);
resultsCurrent.validRows          = height(validatingTT);

resultsCurrent.versionStr = versionStr;

resultsT =  struct2table(resultsCurrent)   ;

if isfile(resultsSaveName)
    % File exists.
    writetable(resultsT,resultsSaveName,"WriteMode","append");
else
    % File does not exist.
    writetable(resultsT,resultsSaveName);
end

% Global CSV  Changed to test CSV
globalCSV   = modelsMatsFolder +"/"+globalCSVLabel + ...
    ".csv";

if isfile(globalCSV)
    % File exists.
    writetable(resultsT,globalCSV,"WriteMode","append");
else
    % File does not exist.
    writetable(resultsT,globalCSV);
end

display(newline);

%% Saving Training Data
trainingSaveNameDaily = getMintsNameGeneral(trainingMatsFolder,nodeID,...
    target,dailyString)
folderCheck(trainingSaveNameDaily)

trainingSaveName      = strrep(trainingSaveNameDaily,dailyString,strcat(versionStr,"/",versionStr))
folderCheck(trainingSaveName)

save(trainingSaveNameDaily,...
    'Mdl',...
    'In_Train',...
    'Out_Train',...
    'In_Validation',...
    'Out_Validation',...
    'trainingTT',...
    'validatingTT',...
    'trainingT',...
    'validatingT',...
    'climateInputs',...
    'climateInputLabels',...
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
    'In_Train',...
    'Out_Train',...
    'In_Validation',...
    'Out_Validation',...
    'trainingTT',...
    'validatingTT',...
    'trainingT',...
    'validatingT',...
    'climateInputs',...
    'climateInputLabels',...
    'target',...
    'targetLabel',...
    'nodeID',...
    'binsPerColumn',...
    'numberPerBin',...
    'pValid' ,...
    'resultsCurrent'...
    )

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
