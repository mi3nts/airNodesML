function mintsData = sensorReadFastV2(dataFiles,Read,timeSpan,sensorID)

    if(length(dataFiles) >0)
        parfor fileNameIndex = 1: length(dataFiles)
               try
                display("Reading: "+dataFiles(fileNameIndex).name+ " " +string(fileNameIndex)) 
                Data{fileNameIndex} =  Read(strcat(dataFiles(fileNameIndex).folder,"/",...
                                   dataFiles(fileNameIndex).name),timeSpan);
                               
                numOfColumns(fileNameIndex) =  width(Data{fileNameIndex});   

             catch e
                display("Error With : "+dataFiles(fileNameIndex).name+"- "+string(fileNameIndex))
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
             end   
        end   
        
    else 
        Data = [];
    end  

    concatStr  =  "mintsData = [";
    for fileNameIndex = 1: length(Data)
        if(mode(numOfColumns)==numOfColumns(fileNameIndex))
            concatStr = strcat(concatStr,"Data{",string(fileNameIndex),"};");
            if(sensorID == "VEML6075")
               Data{fileNameIndex}.Properties.VariableNames = ...
                                Data{length(Data)}.Properties.VariableNames;
            end
        end
    end    
    concatStr  =  strcat(concatStr,"];");

    display(concatStr);
    eval(concatStr);
    
end