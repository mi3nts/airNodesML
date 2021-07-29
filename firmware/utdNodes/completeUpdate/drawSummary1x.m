function [] = drawSummary1x(...
                        dataX,...
                         dataY,...
                         nodeID,...
                          xLabel,...
                            yLabel,...
                             dl1,...
                               titleIn,...
                                Fig_name,...
                                   autoScaleOn,...
                                    limitLow,limitHigh)

%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs  
display("Plotting Graphs for " + titleIn)
%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    plot1 = plot(...
         dataX,...
         dataY);
     
    set(plot1,'DisplayName',dl1);
    
    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    xlabel(xLabel,'FontWeight','bold','FontSize',10);

    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
    
    grid on
    if(autoScaleOn)
        ylim([limitLow,  limitHigh]);
        
    end    
    legend(dl1)
    
    folderCheck(Fig_name);
    saveas(figure_1,char(Fig_name));


end
