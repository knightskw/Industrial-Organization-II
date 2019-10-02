sk1727/Microeconometrics2

clear all; %#ok<CLALL>

%Create global variables that moment functions will use in optimization:
global data x y z s_bar adprice Sk num_obs W Omega sN sN1 M pN pN1; 

%import data:
file_name = '/users/shai/documents/stata/radiodata.csv';
data = readtable(file_name); %reads data in tabular form, allows referencing columns by name

%Extract some required data from our table:
y = data.y; %this is "log(sj)-log(s0)" from first 2SLS regression (the dependent variable) 
z = horzcat(data.numbstatout, data.poptotal2001); %instruments
s_bar = data.s_bar; %"log(withinshare)", we don't need to take log again here.
x = horzcat(ones(274,1), data.ebipercapita, data.northcentral, data.northeast, data.south);
num_obs = length(y); %number of rows in dataset
adprice = data.adprice;
Sk = data.sharein + data.shareout;
sN = data.sN;
sN1 = data.sN1;
M = data.M;
pN = data.pN;
pN1 = data.pN1;

%%%%%%%%%%%%%%%%%%
%%% QUESTION 3 %%%
%%%%%%%%%%%%%%%%%%

%MLE Estimation

% Set initialized values for our guesses of lambda and mu (mu1 is constant
% term)

% Using our values from stata
%                  lambda  mu1   mu2    mu3   mu4    mu5
% param_init_log = [.224, -.844, .0029, .208, .0487, .1084];

% Using values from the paper
%                  lambda   mu1   mu2   mu3    mu4  mu5
% param_init_log = [.224, -.844,  .195, .405, .245, .27];

% Using other values for cross validation (to make sure we
% aren't just getting to a local minimum close to the guess)
 param_init_log = [1,1,1,1,1,1]

% Using fminunc to minimize our negative loglikelihood and report a
% gradient and hessian
%options = optimset('Display','final','MaxFunEvals',1e6,'MaxIter',1e4,'TolFun',1e-12,'TolX',1e-6);
%[param_est_log, val_log, exitflag, output, GRAD, HESSIAN] = fminunc(@(x) loglikelihood(x), param_init_log, options);

% Using fminunc to minimize our negative loglikelihood
 options = optimset('Display','final','MaxFunEvals',1e6,'MaxIter',1e4,'TolFun',1e-12,'TolX',1e-6);
% options = optimset('Display','final','FunValCheck','on','MaxFunEvals',1e6,'MaxIter',1e3,'TolFun',1e-12,'TolX',1e-6);

[param_est_log, val_log] = fminsearch(@(x) loglikelihood(x), param_init_log, options);

% lambda constant mu1 mu2 mu3 mu4
param_est_log

% Calculating Standard Errors (for use with fminunc optimization
% parameter_SE = ones(6,1)
% for k = 1:6
%     parameter_SE(k) = 1./HESSIAN(k,k);
% end    
% parameter estimates can be found in param_est_log
% standard error estimates can be found in parameter_SE
% Uncomment below to get values
% output = horzcat(param_est_log', parameter_SE)
% lambda constant mu1 mu2 mu3 mu4


%%%%%%%%%%%%%%%%%%
%%% QUESTION 4 %%%
%%%%%%%%%%%%%%%%%%
%Joint Estimation of model using GMM
%{ 
    This section sets an initial parameter guess and uses fminsearch
    to find the parameters that minimize the weighted norm of the moment
    conditions specified in Berry and Waldfogel (1999).
%}

%Define weighting matrices (edit 'GMM_Objective.m' to choose weighting matrix):
W = eye(4); %Identity matrix
Omega = eye(4); %alternative weighting matrix, may define later as estimate of optimal...

%Set initial parameter guess (set guess close to STATA results):
%paramater key: [sigma beta1 beta2 beta3 beta4 eta    gamma1 gamma2 gamma3 gamma4]
param_init =    [0.855 0.003 0.021 0.049 0.011 -0.248 0.041  0.163  0.026  0.067]';

%Use fminsearch to find parameters that minimize objective fn:
options = optimset('Display','final','MaxFunEvals',1e6,'MaxIter',1e4,'TolFun',1e-12,'TolX',1e-6);
[param_est, val] = fminsearch(@(x) GMM_Objective(x), param_init, options);