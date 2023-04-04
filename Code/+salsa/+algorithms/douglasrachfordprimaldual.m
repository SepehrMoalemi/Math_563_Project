%% Purpose:  Primal-Dual Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimaldual(prox_tf, prox_g, x, b, i)
    t = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;
    [f_A, f_A_T, ~, f_inv_I_ttATA] = salsa.fft.get_transformations(i.kernel, b, t);

    pk = x.p0;
    qk = x.q0;
    xk = pk;
    
    fprintf('stepsize of t = %G, rho = %G.\n', t, rho);
    fprintf('==================================\n')
    
    
    %% Time Code
    tic
    
    xk_old = xk;
    maxIter = i.maxiter;

    time = 0;
    sample_rate = i.sample_rate;

    indx = 1;
    rel_err = zeros(floor(maxIter/sample_rate),1);
    
    fprintf('Using Rel_Error = ||xk - xk_1||/||xk_1||\n')
    for k = 1:maxIter
        if mod(k, sample_rate) == 0
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);
            iter_rel_err = norm(xk_old - xk)/norm(xk_old);
            fprintf('Rel_Err = %0.2E\n',iter_rel_err);
            rel_err(indx) = iter_rel_err;
            indx = indx + 1;
        end
        xk_old = xk;

        xk = prox_tf(pk);
        zk = salsa.aux.prox_lib.conjProx(prox_g, qk, t);
        a_k = 2*xk - pk;
        b_k = 2*zk - qk;
        wk = f_inv_I_ttATA(a_k) - t*f_inv_I_ttATA(f_A_T(b_k));
        vk = b_k + t*f_A(f_inv_I_ttATA(a_k)) - t^2*f_A(f_inv_I_ttATA(f_A_T(b_k)));
        pk = pk + rho*(wk -xk);
        qk = qk + rho*(vk - zk);
    end

    x = salsa.aux.prox_f(pk);
end
