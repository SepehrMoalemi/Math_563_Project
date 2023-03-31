%% Purpose: Testing boxProx
function test_boxProx()
    % random matrix size mxn in interval (a,b)
    m = 5; n = 1;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n)

    % Get boxProx 
    l = 0; u = 1;
    prox_x = salsa.aux.prox_lib.boxProx(x, l, u)
    
    % Find min sol using matlab
    x = x(:);
    prox = @(y) norm(x - y);
    lb = l*ones(m,n); ub = u*ones(m,n);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],lb,ub,[],options);
    x_opt = reshape(x_opt, m, [])
end

