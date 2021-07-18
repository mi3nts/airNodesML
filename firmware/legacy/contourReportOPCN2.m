
function  valid = contourReportOPCN2(calibrated,nodeID,xLabel,yLabel,titleIn)
% (dataX,dataY,nodeID,xLabel,yLabel,titleIn,givenDate,calibratedFolder,stringIn,autoScaleOn,limit)
%DRAWCONTOURPLOT Summary of this function goes here
%   Detailed explanation goes here

if(height(calibrated)>1)
    
    figure_1= figure('Tag','Contour_Plot',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
        );
    
    contourOut = {...
        'Bin0',...
        'Bin1',...
        'Bin2',...
        'Bin3',...
        'Bin4',...
        'Bin5',...
        'Bin6',...
        'Bin7',...
        'Bin8',...
        'Bin9',...
        'Bin10',...
        'Bin11',...
        'Bin12',...
        'Bin13',...
        'Bin14',...
        'Bin15',...
        };
    
    binBoundriesHigh = [.54,.78,1,1.3,1.6,2.1,3.0,4.0,5.0,6.5,8,10,12,14,16,18];
    binBoundriesLow  = [0.38,.54,.78,1,1.3,1.6,2.1,3.0,4.0,5.0,6.5,8,10,12,14,16];
    binCentersPre        = (binBoundriesHigh+binBoundriesLow)./2;
    
    
    latitudeStringPre = sprintf('%0.8f',calibrated.Latitude(1));
    longitudeStringPre =sprintf('%0.8f',calibrated.Longitude(1));
    latitudeString = strcat(latitudeStringPre,"^o");
    longitudeString =strcat(longitudeStringPre,"^o");
    
    
    for n =1:length(binBoundriesHigh)
        binCenters(n) = string(sprintf('%0.2f',binCentersPre(1,n)));
    end
    
    
    timeIn = hours(calibrated.dateTime - dateshift(calibrated.dateTime(1), 'start', 'day'));
    calibratedTable = timetable2table(calibrated);
    calibratedArray = log10(table2array(calibratedTable(:,contourOut))+1);
    
    contourf(timeIn,[1:16],real(calibratedArray)',50,'LineStyle', 'None');
    yticks([1:1:16]);
    yticklabels(string(binCenters));
    ylabel(yLabel,'FontWeight','bold','FontSize',10);
    xlabel(xLabel,'FontWeight','bold','FontSize',10);
    
        % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
    
    colormap(jet) ;map2 = colormap; map2(1,:) = 1; colormap(map2);
    c = colorbar;
    c.Label.String = 'log_{10}(Particle Counts)';
    
    valid =  true ;
else
    
    valid = false;
    figure_1 = [];
end

end