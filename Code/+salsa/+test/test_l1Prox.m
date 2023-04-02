%% Purpose: Testing l1Prox
function test_l1Prox()
    % Random matrix size mxn in interval (a,b)
    m = 5; n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);

    % Offset
    b = rand(m,n);

    % Get l1 prox
    % || x - b ||_1
    lambda = 2;
    argmin = salsa.aux.prox_lib.l1Prox(x - b, lambda) + b
    
    % Find min sol using matlab
    % Prox_lambda f(x) = argmin { 1/(2*lambda)*||x - y||^2 + f(y) }
    x = x(:); b = b(:);
    f = @(x) norm(x - b,1);
    prox = @(y) (1/(2*lambda))*norm(x - y)^2 + f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);
    x_opt = reshape(x_opt, m, [])

    % Comparing argmins
    prox(argmin(:))
    prox(x_opt(:))
end