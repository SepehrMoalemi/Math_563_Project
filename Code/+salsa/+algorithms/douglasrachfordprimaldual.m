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
    [obj_fun, f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Primal-Dual Douglas-Rachford Splitting Algorithm
    digits = numel(num2str(maxIter));
    pad = repmat(' ',1, 2*digits+4);
    fprintf('%sf_objective | Rel_Err_Val | Rel_Err_Opt\n',pad);
    indx = 1;
    tic
    for k = 1:maxIter
        xk_old = xk;

        xk = prox_tf(pk);
        zk = prox_sgc(qk);
        a_k = 2*xk - pk;
        b_k = 2*zk - qk;
        wk = f_inv_I_ttATA(a_k) - t*f_inv_I_ttATA(f_A_T(b_k));
        vk = b_k + t*f_A(f_inv_I_ttATA(a_k)) - t^2*f_A(f_inv_I_ttATA(f_A_T(b_k)));
        pk = pk + rho*(wk -xk);
        qk = qk + rho*(vk - zk);

        if mod(k, sample_rate) == 0 && i.verbos
            rel_err.val(indx) = f_val_err(xk, xk_old);
            rel_err.opt(indx) = f_opt_err(xk, xk_old);
            f_obj = obj_fun(xk);
            fprintf(['[%',num2str(digits),'d/%d]: '], k, maxIter);
            fprintf('%9.2E  |',f_obj);
            fprintf('%11.2E  |',rel_err.val(indx));
            fprintf('%10.2E\n',rel_err.opt(indx));
            indx = indx + 1;
        end
    end
    xk = prox_tf(pk);
    if i.verbos
        salsa.util.print_completion(rel_err.val, obj_fun(xk), toc);
    end
end