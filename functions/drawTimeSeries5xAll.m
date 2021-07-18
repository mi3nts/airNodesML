function [] = drawTimeSeries5xAll(dataX1,dataY1,...
                                    dataX2,dataY2,...
                                        dataX3,dataY3,...
                                            dataX4,dataY4,...
                                             dataX5,dataY5,...
                                                dl1,dl2,dl3,dl4,dl5,...
                                                nodeID,xLabel,yLabel,...
                                                    titleIn,...
                                                        calibratedFolder,stringIn,...
                                                            autoScaleOn,limit)

%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs  

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
         dataY1,'y');
     
    set(plot1,'DisplayName',dl1);
    
    hold on 
    
      % Create plot
    plot2 = plot(...
         dataX2,...
         dataY2,'c');
     
    set(plot2,'DisplayName',dl2);
    
      % Create plot
    plot3 = plot(...
         dataX3,...
         dataY3,'g');
     
    set(plot3,'DisplayName',dl3);
    
      % Create plot
    plot4 = plot(...
         dataX4,...
         dataY4,'b');
     
    set(plot4,'DisplayName',dl4);
    
          % Create plot
    plot5 = plot(...
         dataX5,...
         dataY5,'k');
     
    set(plot5,'DisplayName',dl5);
    
    legend(dl1,dl2,dl3,dl4,dl5)
    
%     yl=strcat('Mints Node ~=',string(fitresult.p1),'*Grimm Spectrometor','+',string(fitresult.p2)," (\mug/m^{3})")
    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

%     % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

%     Bottom_Title= strcat("R^2 = ", string(rSquared),...
%                         ", RMSE = ",string(rmse));

    title({" ";Top_Title;Bottom_Title},'FontWeight','bold');
%     ylim([0  limit;
    
    grid on
    if(autoScaleOn)
        ylim([0  limit]);
        
    end    

    outFigNamePre    = strcat(calibratedFolder,"/",nodeID,"/",...
                                                   "MINTS_",...
                                                     nodeID,...
                                                     "_",stringIn...
                                                 );  
    
    
    

    
    if ~exist(fileparts(outFigNamePre), 'dir')
        mkdir(fileparts(outFigNamePre));
    end
    
    
    Fig_name = strcat(outFigNamePre,'.png');
    saveas(figure_1,char(Fig_name));
    



end

