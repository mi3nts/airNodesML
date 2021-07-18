function TT = gpsCropCoordinatesUTD(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.latitudeCoordinate_mintsDataGPSGPGGA2>latitude-abs(latRange),:);
    TT= TT(TT.latitudeCoordinate_mintsDataGPSGPGGA2<latitude+abs(latRange),:);
    TT= TT(TT.longitudeCoordinate_mintsDataGPSGPGGA2>longitude-abs(longRange),:);
    TT= TT(TT.longitudeCoordinate_mintsDataGPSGPGGA2<longitude+abs(longRange),:);
end
