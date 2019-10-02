% cprob.m: function to compute the choice probability as a function of x for a 
%          normal continuous mixing distribution for the random coefficient beta in 
%          a binary logit model, so theta(1) is the alpha parameter of the logit,
%          p(1|x,alpha,beta)=1/(1+exp(alpha+x*beta), and theta(2),theta(3) are the
%          (mu,sigma^2) parameters of the normal mixng distribution over beta so
%          we write  p(1|x)= E{P(1|theta(1)+x*beta)|theta(2),theta(3))} where
%          beta ~ N(theta(2),exp(theta)).  John Rust Georgetown University, Feb 2018

function [cpv,dcpv]=cprob(x,theta);   % cpv is choice probability after integrating
                                      % over continuous normal distribution for random 
                                      % beta coefficient, and dcpv is the derivative
                                      % with respect to the parameters

     global qa qw nqp;  % nqp: number quadrature points, qw are quadrature weights
                        %      qa quadrature abcissae, transformed by inverse of 
                        %      a normal CDF

    mu=theta(2);
    ss=exp(theta(3));
     
    cpv=qw(1)./(1+exp(theta(1)+x*(mu+ss*qa(1))));

    for i=2:nqp;
      cpv=cpv+qw(i)./(1+exp(theta(1)+x*(mu+ss*qa(i))));
    end;
