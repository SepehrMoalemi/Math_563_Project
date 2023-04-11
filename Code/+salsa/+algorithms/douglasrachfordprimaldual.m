%% Purpose:  Primal-Dual Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimaldual(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf function_handle
        prox_g  function_handle
        x       struct
        b       double
        i       struct
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


    %% Relative Error Calculations
    if isfield(x, 'x_original')
        f_err = @(xk, xk_old) norm(x.x_original - xk)/norm(x.x_original);
    else
        f_err = @(xk, xk_old) norm(xk_old - xk)/norm(xk_old);
    end

    %% Print Params in use
    if i.verbos
        fprintf('stepsize of t = %G, rho = %G.\n', t, rho);
        fprintf('==================================\n');
        fprintf('Using Rel_Error = ||xk - xk_1||/||xk_1||\n');
    end
    
    %% Time Code
    tic
    
    xk_old = xk;
    maxIter = i.maxiter;

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