function [] = saveResultsV2(resultsCurrent,versionStr,...
                resultsSaveName,modelsMatsFolder,globalCSVLabel,...
                pValid,nodeID,target,binsPerColumn,numberPerBin,...
                trainingTT,validatingTT)

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
