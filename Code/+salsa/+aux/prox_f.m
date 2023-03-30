%% Purpose: Prox of f
% Given x and lambda
% Calculates prox_lambda f
function x = prox_f(x, lambda)
    arguments
        x      (:,:) double
        lambda double {mustBePositive(lambda)} = 1
    end
 
    x = boxProx(x, lambda);
end

