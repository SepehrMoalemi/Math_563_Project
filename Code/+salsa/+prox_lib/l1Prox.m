%% Purpose: Prox of l1-norm
function x = l1Prox(x, lambda, b)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
        b (:,:) double                         = zeros(size(x))
    end
    %% Prox_lambda ||x||1 = sign(xi)(|xi| - lambda)_+
    %{
        Let g(x) = ||x||1, then:
                                 { xi - lambda  for  xi  >  lambda
            Prox_lambda g(x)  =  { 0            for |xi| <= lambda
                                 { xi + lambda  for  xi  < -lambda

        Define f(x) = ||x - b||1, then:
                                 
            Prox_lambda f(x)  = Prox_lambda g(x - b) + b
                                { xi - lambda  for  xi - b  >  lambda
                              = { b            for |xi - b| <= lambda
                                { xi + lambda  for  xi - b  < -lambda
    %}
    x = max(x  - lambda, b) + min(x + lambda, b) - b;
end