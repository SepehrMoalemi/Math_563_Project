%% Purpose: Chambolle-Pock Method
function [xk, rel_err] = chambollepock(prox_tf, prox_g, x, b, i)
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
    arguments
        prox_tf function_handle
        prox_g  function_handle
        x       struct
        b       double
        i       struct
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, ~] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, i.scp);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;

    t = i.tcp; 
    s = i.scp;

    %% Relative Error Calculations
    if isfield(x, 'x_original')
        f_err = @(xk, xk_old) norm(x.x_original - xk)/norm(x.x_original);
    else
        f_err = @(xk, xk_old) norm(xk_old - xk)/norm(xk_old);
    end

    %% Print Params in use
    if i.verbos
        fprintf('stepsize of t = %G, s = %G.\n', t, s);
        fprintf('==================================\n');
        fprintf('Using Rel_Error = ||xk - xk_1||/||xk_1||\n');
    end
    
    %% Time Code
    tic
    
    xk_old = xk;
    maxIter = i.maxiter;

    %% Chambolle-Pock Algorithm
    time = 0;
    sample_rate = i.sample_rate;

    indx = 1;
    rel_err = zeros(floor(maxIter/sample_rate),1);

    for k = 1:maxIter
        if mod(k, sample_rate) == 0 && i.verbos
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);
            iter_rel_err = f_err(xk, xk_old);
            fprintf('Rel_Err = %0.2E\n',iter_rel_err);
            rel_err(indx) = iter_rel_err;
            indx = indx + 1;
        end
        xk_old = xk;

        yk = prox_sgc(yk + s*f_A(zk));
        xk = prox_tf(xk - t*f_A_T(yk));
        zk = 2*xk - xk_old;
    end
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end