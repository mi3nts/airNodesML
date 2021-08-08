
function [lat, lon] = LatLonFromZipCode(Zip)

load zipMap.mat
% ZipInfo
% ZipInfoHeaders

if (ismember(Zip, ZipInfo(:,1)))
    rowN = find( ZipInfo(:,1) == Zip);
else
    rowN = 0;
    lat  = 0;
    lon  = 0;
end

if rowN
    lat = ZipInfo(rowN,2);
    lon = ZipInfo(rowN,3);
    
end
end