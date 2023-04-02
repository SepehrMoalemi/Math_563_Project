%% Purpose: Prox of l2-norm-squared
function x = l2_sq_Prox(x, lambda)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Using Dual Norm
    %{                      
        Prox_lambda ||x||^2  = x/(1 + 2*lambda                      
    %}
     x = x/(1 + 2*lambda);
end

