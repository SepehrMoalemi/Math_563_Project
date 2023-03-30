%% Purpose: Prox of l2-norm
function x = l2_sq_Prox(x, lambda)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Using Dual Norm
    %{
        let s = x/lambda
                             { x - lambda*s/||s|| for  ||s||  >  1
        Prox_lambda ||x||  = { 
                             { x - lambda*s       for  ||s||  <= 1
    %}
    prox = @(X) max(1 - lambda/norm(X,2), 0) * X;

    %% Apply prox to vec/matrix x
    x = salsa.aux.apply_prox(prox, x);
end

