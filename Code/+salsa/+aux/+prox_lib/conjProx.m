%% Purpose: Prox of Conjugate of a function
% Given prox_s of function h
% Calculates prox_s h^*
% Will only be used with prox_g1 and prox_g2
function y = conjProx(prox_h, y, lambda)
%     arguments
%         prox_h   function_handle
%         y      (:,:,3) double
%         lambda double {mustBePositive(lambda)} = 1
%     end
    
    %% Moreau Decomposition
    %{
        Prox_lambda h^*(y) = y - Prox_lambda h(y)
    %}
    y = y - prox_h(y, lambda);
end