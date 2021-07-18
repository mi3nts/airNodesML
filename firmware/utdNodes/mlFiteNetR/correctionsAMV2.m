function  airmarWSTCPre  = correctionsAMV2(airmarWSTCPre)

    airmarWSTCPre.temperature_airmarK =...
                convtemp(airmarWSTCPre.temperature_airmar ,'C','F');
    airmarWSTCPre.dewPoint_airmarK =...
                convtemp(airmarWSTCPre.dewPoint_airmar ,'C','F');            
    airmarWSTCPre.pressure_airmarMBLog  = ...
                log10(airmarWSTCPre.pressure_airmar.*1000);

end
