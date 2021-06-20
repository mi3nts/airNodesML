function mintsData = sensorRead(dataFiles,Read,timeSpan)

    if(length(dataFiles) >0)
        parfor fileNameIndex = 1: length(dataFiles)
              try
                display("Reading: "+dataFiles(fileNameIndex).name+ " " +string(fileNameIndex)) 
                Data{fileNameIndex} =  Read(strcat(dataFiles(fileNameIndex).folder,"/",...
                                                                dataFiles(fileNameIndex).name),timeSpan);
             catch e
                display("Error With : "+dataFiles(fileNameIndex).name+"- "+string(fileNameIndex))
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
             end   
        end      
    end  

    concatStr  =  "mintsData = [";
    for fileNameIndex = 1: length(dataFiles)
        concatStr = strcat(concatStr,"Data{",string(fileNameIndex),"};");
    end    
    concatStr  =  strcat(concatStr,"];");

    display(concatStr);
    eval(concatStr);
    
end