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
    %% Frobenius norm matrix := 2-norm vector
    x = max(1 - lambda/norm(x,'fro'), 0) * x;
end

