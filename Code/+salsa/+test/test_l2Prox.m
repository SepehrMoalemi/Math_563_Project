%% Purpose: Testing l2Prox
function test_l2Prox()
    % random matrix size mxn in interval (a,b)
    m = 5; n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);
    
    % Get l1 prox
    lambda = 2;
    prox_x = salsa.aux.prox_lib.l2_sq_Prox(x, lambda)
    
    % Find min sol using matlab 
    x = x(:);
    f = @(x) norm(x,2)^2;                                 % This should be squared as the prox for this term is for l2 squared.
    prox = @(y) (1/2)*norm(x - y)^2 + lambda*f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);
    x_opt = reshape(x_opt, m, [])
end