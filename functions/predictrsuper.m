function Out = predictrsuper(Super,In)

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized NN model for regression
% disp('Use the hyper-parameter optimized NN model for regression')
Out_NN = Super.Mdl_NN(In')';

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized GPR model for regression
% disp('Use the hyper-parameter optimized GPR model for regression')

Out_GPR = predict(Super.Mdl_GPR,In);


%--------------------------------------------------------------------------
% Use the hyper-parameter optimized Ensemble of Trees model for regression
% disp('Use the hyper-parameter optimized Ensemble of Trees model for regression')

Out_Ensemble = predict(Super.Mdl_Ensemble,In);


%--------------------------------------------------------------------------
% Now train the super learner
% disp('Use the super learner model for regression')

% The model inputs include each of the individual learners
In_Super_Train=[In Out_NN Out_GPR Out_Ensemble];

% Use the fit on the training and validation data

Out_Super = predict(Super.Mdl,In_Super_Train);


%--------------------------------------------------------------------------
% Find the estimated error
% disp('Use the error estimate to update the Super Learner Estimate')

% The model inputs include each of the individual learners
In_Super_Error_Train=[In_Super_Train Out_Super];

% Use the error estimate to update the Super Learner Estimate

Out = predict(Super.MdlError,In_Super_Error_Train)+Out_Super;

