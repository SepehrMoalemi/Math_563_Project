%% Purpose: Testing conjProx
function test_conjProj_l2()
    % random matrix size mxn in interval (a,b)
%     m = 5; n = 1;
%     a = -2; b = 4;
%     x = a + (b-a).*rand(m, n);
% 
%     I = eye(m);
%     b = ones(size(x));
%     
%     % Get l2 prox
%     lambda = 2;
%     prox_x = salsa.prox_lib.l2_sq_Prox(x - b, lambda)
%     t = lambda / 2;
%     prox_x_theory = (1-t*I*inv(I + t*I)*I)*(x + t*I*b)
% 
%     err = @(X) 1/(2*lambda)*norm(X - x + b) + norm(X - b)^2;
%     err(prox_x)
%     err(prox_x_theory)
end