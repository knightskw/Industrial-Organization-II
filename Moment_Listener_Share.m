% Shai Knight-Winnig 2018

%FIRST MOMENT CONDITION FUNCTION: Returns a 2x1 vector (since z has 2 instruments)
%{ 
    This function takes imported data and builds moment conditions 
    to reflect the sample analogue of the theoretical moment condition 
    from equation 9 in paper (Berry and Waldfogel 1999).    

    'param' is the vector of parameters we will estimate via the GMM
    process.  The first few elements of this vector will be used for the first
    moment conditions, and later elements will be used for the second and
    third moment conditions (to be defined in other function files).
%}

function first_moment = Moment_Listener_Share(param)
    global x y z s_bar num_obs; %Global variables we need for this function
    sum = zeros(1,2); %initialize sum of moment conditions to zero
    sigma = param(1); %translate parameters into objects we recognize
    beta = param(2:5); %translate parameters into objects we recognize
    
    %line-by-line computation of moment condition, aggregate and the average
    for i=1:num_obs
        sum = sum + (y(i)-sigma*s_bar(i)-x(i,:)*beta)*z(i,:);
    end
    
    first_moment = sum'/num_obs; %returns sample analogue of moment condition
end