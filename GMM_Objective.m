% Shai Knight-Winnig 2018

%GMM Objective Function to be Minimized
%{ 
    This function constructs the objective function (i.e., weighted norm
    of moments) to be minimized as part of the Generalized Method of Moments 
    (GMM) estimation.  It takes one argument: a parameter of vectors.
    Note that the weighting matrix is hard coded as a global variable 
    in the function so it does not have to be passed as an argument.
    To change the weighting matrix, update this function definition accordingly 
    to use the new desired weighting matrix.
%}

function weighted_norm = GMM_Objective(param)
    %Declare global variables we need for this function and nested fns:
    global W Omega; %#ok<NUSED>
    
    %Choose weighting matrix (W or Omega):
    Weight_Mtx = W;
    
    %Call moment functions:
    moment_1 = Moment_Listener_Share(param); %sample moment condition 1
    moment_2 = Moment_Advertising(param); %sample moment condition 2
    moments = vertcat(moment_1, moment_2); %stack sample moment conditions
    
    %Calculate weighted norm (objective function) to be minimized:
    weighted_norm = moments'*Weight_Mtx*moments; 
end