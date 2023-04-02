%% Purpose: Primal Douglas-Rachford Splitting
function xk = douglasrachfordprimal(prox_tf, prox_g, x, b, i)
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

    %% Chambolle-Pock Algorithm
    for k = 1:maxIter
        if mod(k, 100) == 0
            norm(xk_old - xk)/norm(xk)
        end
        xk_old = xk;

        xk = prox_tf(z1);
        yk = prox_tg(z2);

        uk = f_inv_I_ATA(2*xk - z1 + f_A_T(2*yk - z2));
        
        vk = f_A(uk);
        z1 = z1 + rho*(uk - xk);
        z2 = z2 + rho*(vk - yk);
    end
end

