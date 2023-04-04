%% Purpose: Testing l2-squared-Prox
function result = test_l2_sq_Prox(verbos)
    arguments
        verbos logical = true
    end
    % Random matrix size mxn in interval (a,b)
    m = 5;  n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);
    
    % Offset
    b = rand(m,n);
    
    % Get l2-squared-prox
    % || x - b ||^2
    lambda = 2;
    argmin = salsa.aux.prox_lib.l2_sq_Prox(x, lambda, b);
    
    % Find min sol using matlab 
    % Prox_lambda f(x) = argmin { 1/(2*lambda)*||x - y||^2 + f(y) }
    f = @(x) norm(x - b,'fro')^2;
    prox = @(y) (1/(2*lambda))*norm(x - y,'fro')^2 + f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);

    % Comparing argmins
    fmin_argmin = prox(argmin);
    fmin_solver = prox(x_opt);

    % Print results if verbos
    if verbos
        display(x);
        display(argmin);
        display(x_opt);
        display(fmin_argmin);
        display(fmin_solver);
    end

    tol = 1e-3;
    isClose = @(a, b) max(max(abs(a - b))) < tol;
    result = isClose(fmin_argmin,fmin_solver);
end