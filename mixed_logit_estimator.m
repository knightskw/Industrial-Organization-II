% mixed_logit_estimator: estimation/identification of underling distribution of random coefficients
%                        of a simple example binary logit model under alternative distributions for
%                        unobserved heterogeneity


global nqp qw qa data;

data=load('choice_data.dat');  % load the data set of simulated choices, a 1000 x 4 matrix where
                               % first column is the covariate, x, and the final 3 columns are 0/1
                               % choice dummies (dependent variables) for 3 different specifications
                               % for the distribution of the random coefficient beta of x

% generate quadrature weights, abscissae for normally distributed random coefficient on x
% in the binary logit model.

nqp=20;
[qa,qw]=quadpoints(nqp,0,1);
qa=icdf('normal',qa,0,1);

% the code below is for an analysis of the identification of the model: it calculates the
% nonlinear least squares estimates of the parameters of different specifications for the
% distribution of random coefficients F(beta) for different domains of the x covariate and
% allows for the estimated F(beta) to be different from the true one to see how closely
% we can approximate a true F(beta) using a misspecified F(beta) distribution, such as
% to judge how well a finite mixture specification can approximate a continuous Normal 
% distribution for F(beta) and vice versa. For discrete mixture specifications there can
% be up to 5 points of support.

identification_analysis=0;  % set this to 1 to use nonlinear least squares to find a best-fitting 
                            % distribution F(beta) to the true specification, using the true P(1|x)
                            % (unconditional choice probability of alternative d=1, after integrating
                            % out the random coefficient beta) as the dependent variable in the regression
ml_estimation=1;            % set this to 1 to use maximum likelihood to estimate your chosen model (either 
                            % continuous normally distributed random coefficient F(beta), or a finite mixture
                            % specification with up to 5 points of support) by maximum likelihood

truemixing='continuous';    % a flag to specify the true mixing distribution used to generate P(1|x): continuous vs discrete
estmixing='continuous';     % a flag to specify what type of model to estimate for F(beta): continuyous vs discrete

n_est_types=3;              % if estmixing='discrete' then this gives the number of discrete mass points for F(beta) to estimate
n_true_types=1;             % if trueming='discrete' then this gives the number of discrete mass points for F(beta) used to
                            % calculate true choice probability P(1|x). If truemixing or estmixing is continuous then only
                            % 3 parameters are estimated: theta(1)=alpha (the constant term in the logit) and mu=theta(2) and
                            % sigma=exp(theta(3)), there (mu,sigma^2) are the mean and variance of a continuous normally
                            % distributed specification for F(beta).

if (identification_analysis);


x=(-1:.1:1)';
%x=(-.2:.01:0)';
%x=(-4:.1:4)';
n=size(x,1);

if (strcmp(truemixing,'continuous'));
  thetatrue=[1 2 1]';
  trueprob=cprob(x,thetatrue);
else;
  thetatrue=[1 .5 -.6  1.1 -1 0]';
  trueprob=bprob(x,thetatrue);
end;

if (strcmp(estmixing,'continuous'));
  theta=randn(3,1);
  ssr=@(theta) sum((trueprob-cprob(x,theta)).^2);
else;
  if (n_est_types ==1);
  theta=randn(2,1);
  elseif (n_est_types == 2);
  theta=randn(4,1);
  elseif (n_est_types == 3);
  theta=randn(6,1);
  elseif (n_est_types == 4);
  theta=randn(8,1);
  elseif (n_est_types == 5);
  theta=randn(10,1);
  end;
  ssr=@(theta) sum((trueprob-bprob(x,theta)).^2);
end;

[thetahat,ssrmin]=fminunc(ssr,theta);

fprintf('estimated and true theta\n');
fprintf('estimated theta\n');
thetahat'
fprintf('true theta\n');
thetatrue'
if (size(thetatrue,1) ==4);
   fprintf('true p1=%g\n',1/(1+exp(thetatrue(4))));
end;
if (size(thetatrue,1) ==6);
   fprintf('true p1=%g\n',1/(1+exp(thetatrue(5))+exp(thetatrue(6))));
   fprintf('true p2=%g\n',exp(thetatrue(5))/(1+exp(thetatrue(5))+exp(thetatrue(6))));
end;
if (size(thetahat,1) == 6);
   fprintf('estimated p1=%g\n',1/(1+exp(thetahat(5))+exp(thetahat(6))));
   fprintf('estimated p2=%g\n',exp(thetahat(5))/(1+exp(thetahat(5))+exp(thetahat(6))));
end;
fprintf('minimum objective function %g\n',ssrmin);

if (strcmp(estmixing,'continuous'));
  estprob=cprob(x,thetahat);
else;
  estprob=bprob(x,thetahat);
end;

clf;
figure(1);
hold on;
plot(x,trueprob,'b-','Linewidth',2);
plot(x,estprob,'r-','Linewidth',2);
if (strcmp(estmixing,'discrete'));
legend(sprintf('True, %s heterogeneity',truemixing),sprintf('Estimated, %s heterogeneity, %i types',estmixing,n_est_types),'Location','Best');
else;
legend(sprintf('True, %s heterogeneity',truemixing),sprintf('Estimated, %s heterogeneity',estmixing),'Location','Best');
end;
xlabel('x');
ylabel('P(1|x)');
title('True vs nonlinear least squares approximation to P(1|x)');
hold off;

end;

if (ml_estimation);

  x=data(:,1);
  y=data(:,4);  % this uses the first of the 3 possible dependent variables in the 1000 x 4 matrix data

  if (strcmp(estmixing,'continuous'));
    theta=randn(3,1);
    lf=@(theta) -llf(y,x,theta,@cprob);
  else;
  if (n_est_types ==1);
  theta=randn(2,1);
  elseif (n_est_types == 2);
  theta=randn(4,1);
  elseif (n_est_types == 3);
  theta=randn(6,1);
  elseif (n_est_types == 4);
  theta=randn(8,1);
  elseif (n_est_types == 5);
  theta=randn(10,1);
  end;
  lf=@(theta) -llf(y,x,theta,@bprob);
end;

[thetahat,lfmax]=fminunc(lf,theta);
lfmax=-lfmax;

if (strcmp(estmixing,'continuous'));
fprintf('Optimized value of the log-likelihood for %s normal(mu,sigma^2) specification of random coefficients: %g\n',estmixing,lfmax);
else;
fprintf('Optimized value of the log-likelihood for %s mixture specification of random coefficients with %i discrete types: %g\n',estmixing,n_est_types,lfmax);
end;
fprintf('Estimated parameter vector\n');
thetahat

x=sort(x);

if (strcmp(estmixing,'continuous'));
  estprob=cprob(x,thetahat);
else;
  estprob=bprob(x,thetahat);
end;

clf;
figure(1);
hold on;
plot(x,estprob,'r-','Linewidth',2);
xlabel('x');
ylabel('Estimated P(1|x)');
title('Maximum likelihood estimate of P(1|x)');
hold off;

end;
