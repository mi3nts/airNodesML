
clc

OPCN2Boundries = ...
       [0.38, .54,.78,1,1.3,1.6,2.1,3.0,4,5,6.5,8,10,12,14,16,20];
   
for n = 2:length(OPCN2Boundries)   
    OPCN2BinCenters(n-1) =...
         (OPCN2Boundries(n-1)+OPCN2Boundries(n))/2;
end         
 OPCN2BinCenters'
 binWeightsOPCN2  = (OPCN2BinCenters/2).^3'

 
 
 

OPCN3Boundries = ...
       [0.35,.46,.66,1,1.3,1.7,2.3,3,4,5.2,6.5,8,10,12,14,16,18,20,22,25,28,31,34,37,40];
   
for n = 2:length(OPCN3Boundries)   
    OPCN3BinCenters(n-1) =...
         (OPCN3Boundries(n-1)+OPCN3Boundries(n))/2;
end         
 
 OPCN3BinCenters'   
 binWeightsOPCN3 = (OPCN3BinCenters/2).^3'
