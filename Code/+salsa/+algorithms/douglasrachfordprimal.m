%% Purpose: Primal Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimal(objective, prox_tf, prox_g, x, b, i)
    arguments
        objective   function_handle
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Initialize
    z1 = x.z1;
    z2 = x.z2;

    xk = b;
    xk_old = xk;

    maxIter = i.maxiter;
    t   = i.tprimaldr; 
    rho = i.rhoprimaldr;

    %% Proximal Operator
    prox_tg = @(x) prox_g(x, t);
    
    %% Objective function
    objective_fct = @(x) objective(x, f_A);

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
        fprintf('stepsize of t = %G, rho = %G.\n', t, rho);
        fprintf('==================================\n');
        fprintf('Using Rel_Error_Value = ||xk - xk_1||/||xk_1||\n');
        fprintf('Using Rel_Error_Optimality = (f(x^k) - f(x^*))/f(x^*)\n');
    end

    %% Time Code
    tic
    
    %% Primal Douglas-Rachford Splitting Algorithm
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

        xk = prox_tf(z1);
        yk = prox_tg(z2);

        uk = f_inv_I_ATA(2*xk - z1 + f_A_T(2*yk - z2));
        
        vk = f_A(uk);
        z1 = z1 + rho*(uk - xk);
        z2 = z2 + rho*(vk - yk);
    end
    xk = prox_tf(z1);
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end