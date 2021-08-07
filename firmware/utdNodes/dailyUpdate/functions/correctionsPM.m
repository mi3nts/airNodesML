function inCorrected =  correctionsPM(inCorrected)
% PM Corrections
inCorrected.pm4_palas_predicted((inCorrected.pm2_5_palas_predicted>inCorrected.pm4_palas_predicted),:) =...
    inCorrected.pm2_5_palas_predicted((inCorrected.pm2_5_palas_predicted>inCorrected.pm4_palas_predicted),:) ;

inCorrected.pm1_palas_predicted((inCorrected.pm1_palas_predicted>inCorrected.pm2_5_palas_predicted),:) =...
    inCorrected.pm2_5_palas_predicted((inCorrected.pm1_palas_predicted>inCorrected.pm2_5_palas_predicted),:) ;

inCorrected.pm10_palas_predicted((inCorrected.pm4_palas_predicted>inCorrected.pm10_palas_predicted),:) =...
    inCorrected.pm4_palas_predicted((inCorrected.pm4_palas_predicted>inCorrected.pm10_palas_predicted),:) ;

% Zero Correction
inCorrected.pm1_palas_predicted((inCorrected.pm1_palas_predicted<0),:)=0;
inCorrected.pm2_5_palas_predicted((inCorrected.pm2_5_palas_predicted<0),:)=0;
inCorrected.pm4_palas_predicted((inCorrected.pm4_palas_predicted<0),:)=0;
inCorrected.pm10_palas_predicted((inCorrected.pm10_palas_predicted<0),:)=0;

end