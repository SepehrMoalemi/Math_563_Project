%% Purpose: Testing l1Prox
function test_l1Prox()
    % random matrix size mxn in interval (a,b)
    m = 5; n = 4;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);
    
    % Get l1 prox
    lambda = 2;
    prox_x = salsa.aux.l1Prox(x, lambda)
    
    % Find min sol using matlab
    x = x(:);
    f = @(x) norm(x,1);
    prox = @(y) (1/2)*norm(x - y)^2 + lambda*f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);
    x_opt = reshape(x_opt, m, [])
end