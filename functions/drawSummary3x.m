function [] = drawSummary3x(dataX1,dataY1,...
                                    dataX2,dataY2,...
                                        dataX3,dataY3,...
                                               dl1,dl2,dl3,...
                                                nodeID,xLabel,yLabel,...
                                                    limit,...
                                                    titleIn,...
                                                      fileName)

%GETMINTSDATAFILES Summary of this function goes here

%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    plot1 = plot(...
         dataX1,...
         dataY1,'g');
     
    set(plot1,'DisplayName',dl1);
    
    hold on 
    
      % Create plot
    plot2 = plot(...
         dataX2,...
         dataY2,'b');
     
    set(plot2,'DisplayName',dl2);
          % Create plot
    plot3 = plot(...
         dataX3,...
         dataY3,'r');
     
    set(plot3,'DisplayName',dl3);
    

    legend(dl1,dl2,dl3)
    
    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

    % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
    ylim([0,limit])
    grid on
    
    
    folderCheck(fileName);
    saveas(figure_1,char(fileName));

end