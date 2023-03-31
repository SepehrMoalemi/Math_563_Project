%% Purpose: Prox of f
% Given x and lambda
% Calculates prox_lambda f
function x = prox_f(x)
    arguments
        x      (:,:) double
    end

    %% Box Prox 0<=x<=1
    x = salsa.aux.prox_lib.boxProx(x, 0, 1);
end