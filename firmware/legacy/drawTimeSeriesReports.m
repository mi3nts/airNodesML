function figure_1 = drawTimeSeriesReports(dataX,dataY,nodeID,xLabel,yLabel,titleIn,lowGap,highGap)

%GETMINTSDATAFILES Summary of this function goes here
% Detailed explanation goes here
% As Is Graphs  

import mlreportgen.dom.*;
import mlreportgen.report.*;
%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    
    yLow  = prctile(dataY,1)  - lowGap;
    yHigh = prctile(dataY,99) + highGap;
    
    plot1 = plot(...
         dataX,...
         dataY);
     
    set(plot1,'DisplayName','Data','Marker','.',...
        'LineStyle','none');
      
    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

    % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
  
    ylim([yLow  yHigh]);
 

end