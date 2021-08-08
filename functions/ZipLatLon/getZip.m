
function [ZipCode] = getZip(lat,lon)

load ZipMap.mat

latDif = (ZipInfo(:,2) - lat).^2;
lonDif = (ZipInfo(:,3) - lon).^2;

dif = latDif +lonDif;

[minVal minIndex] = min(dif);
ZipCode = ZipInfo(minIndex,1);


end



