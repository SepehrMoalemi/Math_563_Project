%% Purpose: Prox of g, l2 case
% Given x and lambda
% Calculates prox_lambda g, with 2-norm squared as first term
% the separation of  y can be explained as is done below
% y = Ax = [K; D]x = [ Kx; Dx ] = [ y1; [w1; w2] ]
function y = prox_g2(y, lambda)
    arguments
        y      (:,:,3) double
        lambda double {mustBePositive(lambda)} = 1
    end
    
    y1 = y(:,:,1);
    m = size(y1, 1);
    n = size(y1, 2);
    y1 = reshape(y1, m, n);
    y2 = y(:,:,2:3);
 
    y = l2_sq_Prox(y1, lambda) + isoProx(y2, lambda);
end

