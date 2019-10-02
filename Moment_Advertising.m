% Shai Knight-Winnig 2018

%SECOND MOMENT CONDITION FUNCTION: Returns a 2x1 vector (since z has 2 instruments)
%{ 
    This function takes imported data and builds moment conditions 
    to reflect the sample analogue of the theoretical moment condition 
    from equation 14 in paper (Berry and Waldfogel 1999).    

    'param' is the vector of parameters we will estimate via the GMM
    process.  The middle few elements of this vector will be used for the
    second moment conditions, and other elements will be used for the first and
    third moment conditions (to be defined in other function files).
%}

function second_moment = Moment_Advertising(param)
    global x adprice Sk z num_obs; %Global variables we need for this function
    sum = zeros(1,2); %initialize sum of moment conditions to zero
    eta = param(6); %translate parameters into objects we recognize
    gamma = param(7:10); %translate parameters into objects we recognize
    %line-by-line computation of moment condition, aggregate and the average
    for i=1:num_obs
        sum = sum + (log(adprice(i))-x(i,:)*gamma+eta*log(Sk(i)))*z(i,:);
    end
    
    second_moment = sum'/num_obs; %returns sample analogue of moment condition
end