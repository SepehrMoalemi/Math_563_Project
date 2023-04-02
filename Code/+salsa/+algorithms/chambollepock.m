%% Purpose: Chambolle-Pock Method
function xk = chambollepock(prox_tf, prox_g, x, b, i)
    %{
        solves the generic convex optimization problem:
                min f(x) + g(y)
                x,y
            subject to Ax = y
        by finding the solutions (x^hat, y^hat) of the 
        saddle point problem:
                min max <Ax,y> + f(x) - g^*(y)
                 x   y
        Where A = [K D]'
        convergence is garunteed for s*t*(||A||^2) < 1
    %}

    %% Get fft Transformations
    [f_A, f_A_T, ~, ~] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_sgc = @(x) salsa.aux.prox_lib.conjProx(prox_g, x, i.scp);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;

    xk_old = xk;

    maxIter = i.maxiter;
    t = i.tcp; s = i.scp;

    fprintf('stepsize of t = %G, s = %G.\n', t, s);
    fprintf('==================================\n')

    %% Chambolle-Pock Algorithm
    for k = 1:maxIter
        if mod(k, 100) == 0
            fprintf('Iteration %d/%d : ', k, maxIter);
            fprintf('||xk - xk_1||/||xk_1|| = %G\n',norm(xk_old - xk)/norm(xk_old))
        end
        xk_old = xk;

        yk = prox_sgc(yk + s*f_A(zk));
        xk = prox_tf(xk - t*f_A_T(yk));
        zk = 2*xk - xk_old;
    end
end