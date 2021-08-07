function Mdl = fitRNetOptimized(In,Out,minLayers,maxLayers,MaxEvaluations)

% %--------------------------------------------------------------------------
% nepochs=250;

%--------------------------------------------------------------------------
% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(Out), 'Holdout', 1/3);

%--------------------------------------------------------------------------
% Define hyperparameters to optimize
%% Change when running on Europa
vars = [
        optimizableVariable('hiddenLayer1', [minLayers,maxLayers], 'Type', 'integer');
        optimizableVariable('hiddenLayer2', [minLayers,maxLayers], 'Type', 'integer');
        ];

%--------------------------------------------------------------------------

%% Change when running on Europa
%MaxObjectiveEvaluations=200;
MaxObjectiveEvaluations=MaxEvaluations;
minfn = @(T)kfoldLoss(In', Out', cv, T.hiddenLayer1, ...
                            T.hiddenLayer2);
results = bayesopt( ...
    minfn, ...
    vars, ...
    'MaxObjectiveEvaluations',MaxObjectiveEvaluations, ...
    'UseParallel',true, ...
    'IsObjectiveDeterministic', false, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
     'PlotFcn', []...
);

% Find best results
T = bestPoint(results)

%--------------------------------------------------------------------------
% Train final model on full training set using the best hyperparameters
hiddenLayer1=T.hiddenLayer1;
hiddenLayer2=T.hiddenLayer2;

% Train the Network
 Mdl = train_this_fitrnn(In',Out',hiddenLayer1,hiddenLayer2);

end

%--------------------------------------------------------------------------
function rmse = kfoldLoss(x, y, cv, numHid1,numHid2)

% Train net.

Mdl = fitrnet(x(:,cv.training)', y(:,cv.training)',"Standardize",true, ...
    "LayerSizes",[numHid1,numHid2])

% Evaluate on validation set and compute rmse

rmse = loss(Mdl,x(:,cv.test)', y(:,cv.test)')

end