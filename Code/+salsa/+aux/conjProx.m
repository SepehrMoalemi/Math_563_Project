%% Purpose: Prox of Conjugate of a function
% Given prox_s f
% Calculates prox_s f^*
function x = conjProx(prox, x, s)
    arguments
        prox   function_handle
        x      (:,:,2) double
        s double {mustBePositive(s)} = 1
    end
    
    %% Moreau Decomposition
    %{
        Prox_s f^*(x) = x - s*Prox_(1/s)f(x/s)
    %}
 
    x = x - s*prox(x/s, 1/s);
end