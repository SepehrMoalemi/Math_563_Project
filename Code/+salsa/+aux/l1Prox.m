%% Purpose: Prox of l1-norm
function x = l1Prox(x, lambda)
    arguments
        x
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Prox_lambda ||x||1 = sign(xi)(|xi| - lambda)_+
    %{
                             { xi - lambda  for  xi  >  lambda
        Prox_lambda ||x||1 = { 0            for |xi| <= lambda
                             { xi + lambda  for  xi  < -lambda
    %}
    prox = @(X) max(X - lambda, 0) + min(X + lambda, 0);

    %% Apply prox to vec/matrix x
    x = salsa.aux.apply_prox(prox, x);
end

