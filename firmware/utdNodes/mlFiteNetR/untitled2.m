for n = 1 : width(mintsData_001e06318c91)
    varName = mintsData_001e06318c91.Properties.VariableNames{n}
    if ~any(ismember(mintsData_001e06318c91_Kept.Properties.VariableNames,...
                mintsData_001e06318c91.Properties.VariableNames{n}))
        
        eval(strcat("mintsData_001e06318c91_Kept.",varName,"(:)=nan;"));
            
    end     
    
end 