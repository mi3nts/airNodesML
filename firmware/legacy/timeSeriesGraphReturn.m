function figure_1 = timeSeriesGraphReturn(dataX,dataY,nodeID,xLabel,yLabel,titleIn)
import mlreportgen.dom.*;
import mlreportgen.report.*;

figure_1= figure('Tag','SCATTER_PLOT',...
    'NumberTitle','off',...
    'units','pixels','OuterPosition',[0 0 900 675],...
    'Name','TimeSeries',...
    'Visible','on'...
    );


% Create plot
plot1 = plot(...
    dataX,...
    dataY);

set(plot1,'DisplayName','Data','Marker','x',...
    'LineStyle','none');

ylabel(yLabel,'FontWeight','bold','FontSize',10);

% Create xlabel
xlabel(xLabel,'FontWeight','bold','FontSize',10);

%     % Create title
Top_Title=strcat(titleIn);

Bottom_Title = strcat("Node " +string(nodeID));

title({" ";Top_Title;Bottom_Title},'FontWeight','bold');

grid on


end