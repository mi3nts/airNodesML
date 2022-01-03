function ZipLatLon(Zip1, Zip2)
%ZIPLATLON Finds the a combination of latidue, longitude, Zip Code in the United States and
%   distance in between two of points.
% 
%   
%   LATLONFROMZIPCODE: Get Latitude and Longitude from given Zip Code: 
%   [LAT1, LON1] = LATLONFROMZIPCODE(ZIP1)
%   GET_ZIPCODE: Get the Zipcode from a given point with Latitude and longitude.
%   [ZIPCODE1] = GET_ZIPCODE(LAT1, LON1)
%   ZIPDISTANCE : Find the distance between the two zipcodes. 
%   [ZDIS] = ZIPDISTANCE(ZIP1, ZIP2)
% 
%   Map look up for the Zip Code Latitude Longitude City State County CSV
%   was supported August 24, 2013 by Thai Yin.
%   A convenient file with all the US zip codes and their associated
%   latitude, longitude, city, state, and county. was supported August 24,
%   2013 by Thai Yin. Mapping modules in Drupal and WordPress may require
%   this database which isn’t always included due to size.
%   http://notebook.gaslampmedia.com/download-zip-code-latitude-longitude-city-state-county-csv/
%   
%   The map then was converted to matlab data file (.mat) file
%   First, finding the lat and lon data associated with the desired zipcode, then using
%   the built-in DISTANCE function in MATLAB to find the distance between
%   the two given zip codes.
%
% Example:
% Zip1 = 48306 % Rochester, MI
% Zip2 = 67337 % Coffeyville, KS
% ZDis = ZipDistance(Zip1, Zip2)
%
%   See also DISTANCE.

% Copyright @ Sami Oweis,
% $Revision: 1.0.1 $  $Date: 2014/03/16 $


Zip1 = 48306 % Rochester, MI
Zip2 = 67337 % Coffeyville, KS

%%  Get Latitude and Longitude
[lat1, lon1] = LatLonFromZipCode(Zip1)
[lat2, lon2] = LatLonFromZipCode(Zip2)


%% Get ZipCode
[ZipCode1] = Get_ZipCode(lat1, lon1)
[ZipCode2] = Get_ZipCode(lat2, lon2)

%% Find distance:
ZDis = distance(lat1,lon1,lat2,lon2)

end

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
function [ZipCode] = Get_ZipCode(lat,lon)

load zipMap.mat
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



