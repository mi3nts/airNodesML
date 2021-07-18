function [] = drawTimeSeries3x(dataX1,dataY1,...
                                    dataX2,dataY2,...
                                        dataX3,dataY3,...
                                               dl1,dl2,dl3,...
                                                nodeID,xLabel,yLabel,...
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
         dataY1,'bx');
     
    set(plot1,'DisplayName',dl1);
    
    hold on 
    
      % Create plot
    plot2 = plot(...
         dataX2,...
         dataY2,'rx');
     
    set(plot2,'DisplayName',dl2);
          % Create plot
    plot3 = plot(...
         dataX3,...
         dataY3,'g+');
     
    set(plot3,'DisplayName',dl3);
    

    legend(dl1,dl2,dl3)
    
    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

    % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
    
    grid on
    
    
    if ~exist(fileparts(fileName), 'dir')
        mkdir(fileparts(outFigNamePre));
    end
    
    saveas(figure_1,char(fileName));

end