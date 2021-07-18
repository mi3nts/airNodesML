
function [In_Train,Out_Train,...
            In_Validation,Out_Validation,...
               trainingTT, validatingTT,...
                trainingT, validatingT ] ...
                            = representativeSampleSimpleTT(timeTableIn,inputVariables,target,pvalid)

    [trainInd,valInd,testInd] = dividerand(height(timeTableIn),1-pvalid,0,pvalid);

    tableIn  =  timetable2table(timeTableIn);            
    In       =  table2array(tableIn(:,inputVariables));
    Out      =  table2array(tableIn(:,target)); 

    In_Train       = In(trainInd,:);
    In_Validation  = In(testInd,:);

    Out_Train      = Out(trainInd);
    Out_Validation = Out(testInd);           

    trainingTT     = timeTableIn(trainInd ,[{inputVariables{:},target}]);
    validatingTT   = timeTableIn(testInd  ,[{inputVariables{:},target}]);

    trainingT          = timetable2table(trainingTT);
    validatingT        = timetable2table(validatingTT);

    trainingT.dateTime   = [];
    validatingT.dateTime = [];   
    
end
