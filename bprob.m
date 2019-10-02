function [bpv]=bprob(x,theta);
  k=size(theta,1);
  if (k == 2);  % one type (homogeneous) specification

    bpv=1./(1+exp(theta(1)+x*theta(2)));

  elseif (k == 4);  % two types (heterogeneous) specification
   
    p=1/(1+exp(theta(4))); 
    bpv=p./(1+exp(theta(1)+x*theta(2)));
    bpv=bpv+(1-p)./(1+exp(theta(1)+x*theta(3)));

  elseif (k == 6);  % three types specification
   
    p1=1/(1+exp(theta(5))+exp(theta(6))); 
    p2=exp(theta(5))/(1+exp(theta(5))+exp(theta(6))); 
    p3=exp(theta(6))/(1+exp(theta(5))+exp(theta(6))); 
    bpv=p1./(1+exp(theta(1)+x*theta(2)));
    bpv=bpv+p2./(1+exp(theta(1)+x*theta(3)));
    bpv=bpv+p3./(1+exp(theta(1)+x*theta(4)));

  elseif (k == 8);  % four types specification
  
    d=1+exp(theta(6))+exp(theta(7))+exp(theta(8)); 
    p1=1/d;
    p2=exp(theta(6))/d;
    p3=exp(theta(7))/d;
    p4=exp(theta(8))/d;
    bpv=p1./(1+exp(theta(1)+x*theta(2)));
    bpv=bpv+p2./(1+exp(theta(1)+x*theta(3)));
    bpv=bpv+p3./(1+exp(theta(1)+x*theta(4)));
    bpv=bpv+p4./(1+exp(theta(1)+x*theta(5)));

  elseif (k == 10);  % five types specification
  
    d=1+exp(theta(7))+exp(theta(8))+exp(theta(9))+exp(theta(10)); 
    p1=1/d;
    p2=exp(theta(7))/d;
    p3=exp(theta(8))/d;
    p4=exp(theta(9))/d;
    p5=exp(theta(10))/d;
    bpv=p1./(1+exp(theta(1)+x*theta(2)));
    bpv=bpv+p2./(1+exp(theta(1)+x*theta(3)));
    bpv=bpv+p3./(1+exp(theta(1)+x*theta(4)));
    bpv=bpv+p4./(1+exp(theta(1)+x*theta(5)));
    bpv=bpv+p5./(1+exp(theta(1)+x*theta(6)));

  end;
