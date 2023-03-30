%% Purpose: Testing l2Prox
function test_l2Prox()
    % random matrix size mxn in interval (a,b)
    m = 5; n = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n);
    
    % Get l1 prox
    lambda = 2;
    prox_x = salsa.aux.l2Prox(x, lambda)
    
    % Find min sol using matlab
    x_opt = zeros(m,n);
    f = @(x) norm(x,2);
    for i=1:n
        xi = x(:,i);
        prox = @(y) (1/2)*norm(xi - y)^2 + lambda*f(y);
        options = optimoptions('fmincon', 'Display','none');
        x_opt(:,i) = fmincon(prox,xi,[],[],[],[],[],[],[],options);
    end
    x_opt
end