%% Purpose: Testing isoProx
function test_isoProx()
    % random matrix size mxn in interval (a,b)
    m = 5; n = 2; k = 2;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n, k);
    
    % Get  iso prox
    lambda = 2;
%     prox_x = salsa.aux.prox_lib.isoProx(x, lambda)
%     
    % Get matrix form
    x1 = x(:,:,1); x1 = x1(:);
    x2 = x(:,:,2); x2 = x2(:);
    x = cat(2,x1,x2);
    x_mat_opt = isoProx_matrix(x, lambda)

    % Find min sol using matlab 
    prox = @(y) (1/2)*norm(x - y,'fro')^2 + lambda*norm_iso(y);
    options = optimoptions('fmincon', 'Display','none');
    x_opt = fmincon(prox,x,[],[],[],[],[],[],[],options);
    x_opt = reshape(x_opt, m, n , k)
end

%% Iso Norm
function result = norm_iso(x)
    [m, n, k] = size(x);

    result = 0;

    % For Matrix
    if k == 1
        for i=1:m
            result = result + sqrt(x(i,1)^2 + x(i,2)^2);
        end
    
    % For Tensor
    else
        for i=1:m
            for j=1:n
                result = result + sqrt(x(i,j,1)^2 + x(i,j,2)^2);
            end
        end
    end
end

%% test matrix prox
function x = isoProx_matrix(x, lambda)
    [m, n] = size(x);
    for i = 1:m
        if sqrt(x(i,1)^2 + x(i,2)^2) > lambda
            alpha = 1 - lambda/sqrt(x(i,1)^2 + x(i,2)^2);
            x(i,:) = alpha * x(i,:);
        end
    end
end