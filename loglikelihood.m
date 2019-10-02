% Calculates a log-likelihood for every row, then sums them up and negates

function value = loglikelihood(param)
    global x sN sN1 M pN pN1 num_obs;
    lambda = param(1);
    mu = ones(5,1);
    mu(1) = param(2);
    mu(2) = param(3);
    mu(3) = param(4);
    mu(4) = param(5);
    mu(5) = param(6);
    value = 0;
        for k = 1:num_obs
            a = normcdf((1/lambda)*(log(M(k,:)*pN(k,:)*sN(k,:))-x(k,:)*mu)); % first half of equation 7
            b = normcdf((1/lambda)*(log(M(k,:)*pN1(k,:)*sN1(k,:))-x(k,:)*mu)); % second half of equation 7
            c = log(a-b); 
            value = c + value;
        end
    value = -(value); % Negate so we can use a minimization function to solve
end