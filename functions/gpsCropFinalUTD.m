function TT = gpsCropFinalUTD(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.Latitude >latitude-abs(latRange),:);
    TT= TT(TT.Latitude <latitude+abs(latRange),:);
    TT= TT(TT.Longitude>longitude-abs(longRange),:);
    TT= TT(TT.Longitude<longitude+abs(longRange),:);
end
