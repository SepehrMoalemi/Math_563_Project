%% Purpose: Testing boxProx
function result = test_boxProx(verbos)
    arguments
        verbos logical = true
    end
    % Random matrix size mxn in interval (a,b)
    m = 5; n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);

    % Get boxProx 
    lambda = 2;
    l = 0; u = 1;
    argmin = salsa.aux.prox_lib.boxProx(x, l, u);
    
    % Find min sol using matlab
    % S = {s : l<=s<=u}
    % Prox_lambda f(x) = argmin { 1/(2*lambda)*||x - y||^2 + indicator_S(x) }
    lb = l*ones(m,n); ub = u*ones(m,n); %<---- used to set bounds of fmincon
    prox = @(y) 1/(2*lambda)*norm(x - y, "fro");
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],lb,ub,[],options);

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

