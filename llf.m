% llf.m:  mixed logit log likelihood function


  function [llfv]=llf(y,x,theta,prob);

  llfv=prob(x,theta);

  llfv=sum(log(y.*llfv+(1-y).*(1-llfv)));
