function [xk, rel_err] = admm(objective, prox_tf, prox_g, x, b, i)
    arguments
        objective   function_handle
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end
  %{ 
TO BE ADJUSTED
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
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;
    uk = x.u0;
    wk = x.w0;

    maxIter = i.maxiter;
    t   = i.tcp;           
    rho = i.rho;
    

    %% Get Prox g
    prox_tg = @(x) prox_g(x, 1/t);
    
    %% Objective function
    objective_fct = @(x) objective(x, f_A);

    %% Relative Error Calculations
    if isfield(x, 'x_original')
        f_val_err = @(xk, xk_old) norm(x.x_original - xk)/norm(x.x_original);
        opt_original = objective_fct(x.x_original);
        f_opt_err = @(xk, xk_old) abs(objective_fct(xk) - opt_original)/opt_original;
    else
        f_val_err = @(xk, xk_old) norm(xk_old - xk)/norm(xk_old);
        f_opt_err = @(xk, xk_old) abs(objective_fct(xk) - objective_fct(xk_old))/objective_fct(xk_old);
    end

    %% Print Params in use
    if i.verbos
        fprintf('stepsize of t = %G, rho = %G.\n', t, rho);
        fprintf('==================================\n');
        fprintf('Using Rel_Error_Value = ||xk - xk_1||/||xk_1||\n');
        fprintf('Using Rel_Error_Optimality = (f(x^k) - f(x^*))/f(x^*)\n');
    end

    %% ADMM Algorithm
    tic

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

        xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + wk/t);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + zk/t);
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);
    end
    xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end