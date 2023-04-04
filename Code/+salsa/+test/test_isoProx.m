%% Purpose: Testing isoProx
function result = test_isoProx(verbos)
    arguments
        verbos logical = true
    end
    % random matrix size mxn in interval (a,b)
    m = 5; n = 2; k = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n, k);
    
    % Get  iso prox
    lambda = 2;
    argmin = salsa.aux.prox_lib.isoProx(x, lambda) ;

    % Find min sol using matlab 
    % Prox_lambda f(x) = argmin { 1/(2*lambda)*||x - y||^2 + f(y) }
    f    = @(y) norm_iso(y);
    prox = @(y) (1/(2*lambda))*norm(x(:,:,1) - y(:,:,1),'fro')^2 + ...
                (1/(2*lambda))*norm(x(:,:,2) - y(:,:,2),'fro')^2 + ...
                f(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);
    x_opt = reshape(x_opt, m, n , k);

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

%% Iso Norm
function result = norm_iso(x)
    [m, n, k] = size(x);
    result = 0;

    % For Matrix
    %{
        let x be in R^(m*n) st:
            x = (x1,x2) for x1,x2 in R^(m) 
        Then:
        ||(x1,x2)||_iso = sum(x1_k, x2_k) for k=1:m
    %}
    
    if k == 1
        for i=1:m
            result = result + sqrt(x(i,1)^2 + x(i,2)^2);
        end
    
    % For Tensor
    %{
        let x be in R^(m*n*2) st:
            x = (x1,x2) for x1,x2 in R^(m*n) 
        Then:
        ||(x1,x2)||_iso = sum(x1_ij, x2_ij) for i=1:m, j=1:n
    %}
    else
        for i=1:m
            for j=1:n
                result = result + sqrt(x(i,j,1)^2 + x(i,j,2)^2);
            end
        end
    end
end