%% Purpose:  Primal-Dual Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimaldual(objective, prox_tf, prox_g, x, b, i)
    arguments
        objective   function_handle
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Get fft Transformations    
    t = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;
    [f_A, f_A_T, ~, f_inv_I_ttATA] = salsa.fft.get_transformations(i.kernel, b, t);

    %% Initialize
    pk = x.p0;
    qk = x.q0;
    xk = pk;

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, t);
    
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
    
    xk_old = xk;
    maxIter = i.maxiter;

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

        xk = prox_tf(pk);
        zk = prox_sgc(qk);
        a_k = 2*xk - pk;
        b_k = 2*zk - qk;
        wk = f_inv_I_ttATA(a_k) - t*f_inv_I_ttATA(f_A_T(b_k));
        vk = b_k + t*f_A(f_inv_I_ttATA(a_k)) - t^2*f_A(f_inv_I_ttATA(f_A_T(b_k)));
        pk = pk + rho*(wk -xk);
        qk = qk + rho*(vk - zk);
    end
    xk = prox_tf(pk);
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end