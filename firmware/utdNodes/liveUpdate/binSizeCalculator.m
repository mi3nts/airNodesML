

OPCN2Boundries = ...
       [0.38, .54,.78,1,1.3,1.6,2.1,3.0,4,5,6.5,8,10,12,14,16,20];
   
for n = 2:length(OPCN2Boundries)   
    OPCN2BinCenters(n-1) =...
         (OPCN2Boundries(n-1)+OPCN2Boundries(n))/2;
end         
 
 binWeights = (OPCN2BinCenters/2).^3'
