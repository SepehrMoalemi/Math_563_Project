%% Purpose: Prox of l2-norm-squared
function x = l2_sq_Prox(x, lambda, b)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
        b (:,:) double                         = zeros(size(x))
    end
    %% Using Dual Norm
    %{             
        Let g(x) = ||x||^2, then:                
            Prox_lambda g(x)  = x/(1 + 2*lambda)  

        Define f(x) = ||x - b||^2, then:
            Prox_lambda f(x) = Prox_lambda g(x - b) + b
                             = (x + 2*lambda*b) /(1 + 2*lambda)

        By default, assume b = 0 s.t. f(x) = g(x) 
    %}
     x = (x + 2*lambda*b) /(1 + 2*lambda);
end

