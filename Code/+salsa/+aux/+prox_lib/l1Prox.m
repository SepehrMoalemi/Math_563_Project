%% Purpose: Prox of l1-norm
function x = l1Prox(x, lambda)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Prox_lambda ||x||1 = sign(xi)(|xi| - lambda)_+
    %{
                             { xi - lambda  for  xi  >  lambda
        Prox_lambda ||x||1 = { 0            for |xi| <= lambda
                             { xi + lambda  for  xi  < -lambda
    %}
    x = max(x - lambda, 0) + min(x + lambda, 0);
end

