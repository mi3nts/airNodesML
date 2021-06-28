function TT = gpsCropUTD(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.GPSGPGGA2_latitudeCoordinate>latitude-abs(latRange),:);
    TT= TT(TT.GPSGPGGA2_latitudeCoordinate<latitude+abs(latRange),:);
    TT= TT(TT.GPSGPGGA2_longitudeCoordinate>longitude-abs(longRange),:);
    TT= TT(TT.GPSGPGGA2_longitudeCoordinate<longitude+abs(longRange),:);
end
