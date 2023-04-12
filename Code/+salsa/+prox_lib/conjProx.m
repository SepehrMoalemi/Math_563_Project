%% Purpose: Prox of Conjugate of a function
% Given prox_s of function h
% Calculates prox_s h^*
% Will only be used with prox_g1 and prox_g2
function y = conjProx(prox_h, y, lambda)
    arguments
        prox_h function_handle
        y      (:,:,3) double
        lambda double {mustBePositive(lambda)} = 1
    end
    
    %% Moreau Decomposition
    %{
        Prox_s h^*(y) = y - s*Prox_(1/s) h(y/s)
    %}
    y = y - lambda*prox_h(y/lambda, 1/lambda);
end