%% Purpose: Chambolle-Pock Method
function [xk, rel_err] = chambollepock(objective, prox_tf, prox_g, x, b, i)
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
        objective   function_handle
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, ~] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, i.scp);
    
    %% Objective function
    objective_fct = @(x) objective(x, f_A);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;

    t = i.tcp; 
    s = i.scp;

    %% Relative Error Calculations
    if isfield(x, 'x_original')
        f_val_err = @(xk, xk_old) norm(x.x_original - xk)/norm(x.x_original);
        opt_original = objective_fct(x.x_original);
        f_opt_err = @(xk, xk_old) (objective_fct(xk) - opt_original)/opt_original;
    else
        f_val_err = @(xk, xk_old) norm(xk_old - xk)/norm(xk_old);
        f_opt_err = @(xk, xk_old) (objective_fct(xk) - objective_fct(xk_old))/objective_fct(xk_old);
    end
    
    %% Print Params in use
    if i.verbos
        fprintf('stepsize of t = %G, s = %G.\n', t, s);
        fprintf('==================================\n');
        fprintf('Using Rel_Error_Value = ||xk - xk_1||/||xk_1||\n');
        fprintf('Using Rel_Error_Optimality = (f(x^k) - f(x^*))/f(x^*)\n');
    end
    
    %% Time Code
    tic
    
    xk_old = xk;
    maxIter = i.maxiter;

    %% Chambolle-Pock Algorithm
    time = 0;
    sample_rate = i.sample_rate;

    indx = 1;
    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    for k = 1:maxIter
        if mod(k, sample_rate) == 0 && i.verbos
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);
            iter_rel_err_val = f_val_err(xk, xk_old);
            fprintf('Val_Err = %0.2E ',iter_rel_err_val);
            rel_err.val(indx) = iter_rel_err_val;
            iter_rel_err_opt = f_opt_err(xk, xk_old);
            fprintf('Opt_Err = %0.2E\n',iter_rel_err_opt);
            rel_err.opt(indx) = iter_rel_err_opt;
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