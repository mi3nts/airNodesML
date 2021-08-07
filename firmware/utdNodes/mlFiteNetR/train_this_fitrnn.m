function Mdl = train_this_fitrnn(In_Train,Out_Train,...
                                    hiddenLayer1,hiddenLayer2)
x = In_Train';
t = Out_Train';

% Train the Network
Mdl = fitrnet(x,t,"Standardize",true, ...
    "LayerSizes",[hiddenLayer1,hiddenLayer2])
% iteration = Mdl.TrainingHistory.Iteration;
% trainLosses = Mdl.TrainingHistory.TrainingLoss;
% valLosses = Mdl.TrainingHistory.ValidationLoss;
% plot(iteration,trainLosses,iteration,valLosses)
% legend(["Training","Validation"])
% xlabel("Iteration")
% ylabel("Mean Squared Error")

end