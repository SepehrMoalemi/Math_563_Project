%% Purpose:  Primal-Dual Douglas-Rachford Splitting
function x = douglasrachfordprimaldual(prox_g, x, b, i)
    t = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;
    [f_A, f_A_T, ~, f_inv_I_ttATA] = salsa.fft.get_transformations(kernel, b, t);
    
    pk = x;
    qk = f_A(x);
    
    for i = 1:max_iter
        xk = salsa.aux.prox_f(pk, t);
        zk = salsa.aux.conjProx(prox_g(qk, t));
        a = 2*xk - pk;
        b = 2*zk - qk;
        wk = f_inv_I_ttATA(a) - t*f_inv_I_ttATA(f_A_T(b));
        vk = b + t*f_A(f_inv_I_ttATA(a)) - t^2*f_A(f_inv_I_ttATA(f_A_T(b)));
        pk = pk + rho*(wk -xk);
        qk = qk + rho*(vk - zk);
    end
    
    x = salsa.aux.prox_f(pk, t);
end

