%% Purpose: Primal-Dual Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimaldual(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Initialize
    pk = x.p0;
    qk = x.q0;
    xk = pk;

    t   = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;

    %% Print Params in use
    if i.verbos
        salsa.util.print_param(t, rho);
    end

    %% Get fft Transformations    
    [f_A, f_A_T, ~, f_inv_I_ttATA] = salsa.fft.get_transformations(i.kernel, b, t);

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, t);
    
    %% Relative Error Calculations
    [f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    xk_old = xk;
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Primal-Dual Douglas-Rachford Splitting Algorithm
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