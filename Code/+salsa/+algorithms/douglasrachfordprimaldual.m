%% Purpose:  Primal-Dual Douglas-Rachford Splitting
function x = douglasrachfordprimaldual(prox_tf, prox_g, x, b, i)
    t = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;
    [f_A, f_A_T, ~, f_inv_I_ttATA] = salsa.fft.get_transformations(i.kernel, b, t);
    
    pk = x.p0;
    qk = x.q0;
    
    xk = pk;
    xk_old = pk;

    for k = 1:i.maxiter
        if mod(k, 100) == 0
            fprintf('Iteration %d/%d : ', k, i.maxiter);
            fprintf('||xk - xk_1||/||xk_1|| = %G\n',norm(xk_old - xk)/norm(xk_old))
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