

function TT = gpsCropCoord(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.latitudeCoordinate>latitude-abs(latRange),:);
    TT= TT(TT.latitudeCoordinate<latitude+abs(latRange),:);
    TT= TT(TT.longitudeCoordinate>longitude-abs(longRange),:);
    TT= TT(TT.longitudeCoordinate<longitude+abs(longRange),:);
    
end
