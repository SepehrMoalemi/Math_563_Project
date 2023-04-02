%% Purpose: Testing l2-squared-Prox
function test_l2_sq_Prox()
    % Random matrix size mxn in interval (a,b)
    m = 5;  n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n)
    
    % Offset
    b = rand(m,n);
    
    % Get l2-squared-prox
    % || x - b ||^2
    lambda = 2;
    argmin = salsa.aux.prox_lib.l2_sq_Prox(x - b, lambda) + b
    
    % Find min sol using matlab 
    % Prox_lambda f(x) = argmin { 1/(2*lambda)*||x - y||^2 + f(y) }
    f = @(x) norm(x - b,'fro')^2;
    prox = @(y) (1/(2*lambda))*norm(x - y,'fro')^2 + f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options)

    % Comparing argmins
    prox(argmin)
    prox(x_opt)
end