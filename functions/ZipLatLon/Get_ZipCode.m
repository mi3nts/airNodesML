
function [ZipCode] = Get_ZipCode(lat,lon)

load ZipMap.mat
% ZipInfo
% ZipInfoHeaders

% to get correct ZipCode we need to get the lat and lon data in 4 decimal
% places.

facV = 10000;
lat = fix(facV* lat)/facV;
lon = fix(facV* lon)/facV;
ZipInfo(:,2) = fix(ZipInfo(:,2).*facV)./facV;
ZipInfo(:,3) = fix(ZipInfo(:,3).*facV)./facV;
row1 = 0;
row2 = 0;
ZipCode  = 0;


if (ismember(lat, ZipInfo(:,2)))
    row1= find( ZipInfo(:,2) == lat);
end

if (row1)
    if (ismember(lon, ZipInfo(row1,3)))
        row2 = find( ZipInfo(:,3) == lon);
        
        if (row2)
            ZipCode = ZipInfo(row2,1);
        end
    end
end
end



