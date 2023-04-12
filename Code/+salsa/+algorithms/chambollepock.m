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
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;

    t = i.tcp; 
    s = i.scp;

    %% Print Params in use
    if i.verbos
        salsa.util.print_param(t, s);
    end


    %% Get fft Transformations
    [f_A, f_A_T, ~, ~] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, i.scp);

    %% Relative Error Calculations
    [f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    xk_old = xk;
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Chambolle-Pock Algorithm
    time = 0; indx = 1;
    tic
    for k = 1:maxIter
        if mod(k, sample_rate) == 0 && i.verbos
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);

            rel_err.val(indx) = f_val_err(xk, xk_old);
            fprintf('Val_Err = %0.2E ',rel_err.val(indx));

            rel_err.opt(indx) = f_opt_err(xk, xk_old);
            fprintf('Opt_Err = %0.2E\n',rel_err.opt(indx));

            indx = indx + 1;
            if mod(k, 100) == 0
                figure('Name','Deblurred Image' );
                imshow(xk,[]);
            end
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