
function mintsData = sensorReadSolo(dataFiles,Read,timeSpan)
    if(length(dataFiles) >0)
        try
           display("Reading: "+dataFiles.name)
           mintsData =  Read(strcat(dataFiles.folder,"/",...
                                      dataFiles.name),timeSpan);
        catch e
           display("Error With : "+dataFiles.name)
           fprintf(1,'The identifier was:\n%s',e.identifier);
           fprintf(1,'There was an error! The message was:\n%s',e.message);
        end
    else 
        mintsData = [];
    end
end