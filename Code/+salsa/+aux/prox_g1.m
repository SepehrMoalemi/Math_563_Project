%% Purpose: Prox of g, l1 case
% Given x and lambda
% Calculates prox_lambda g, with 1-norm as first term
% y = Ax = [K; D]x = [ Kx; Dx ] = [ y1; [w1; w2] ]
function y = prox_g1(y, lambda)
    arguments
        y      (:,:,3) double
        lambda double {mustBePositive(lambda)} = 1
    end
    
    y1 = y(:,:,1);
    m = size(y1, 1);
    n = size(y1, 2);
    y1 = reshape(y1, m, n);
    y2 = y(:,:,2:3);
 
    y = l1Prox(y1, lambda) + prox_iso(y2, lambda);
end

