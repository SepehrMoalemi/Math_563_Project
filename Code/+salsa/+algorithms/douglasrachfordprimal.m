%% Purpose: Primal Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimal(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

    %% Initialize
    z1 = x.z1;
    z2 = x.z2;
    xk = b;

    t   = i.tprimaldr; 
    rho = i.rhoprimaldr;

    %% Print Params in use
    if i.verbos
        salsa.util.print_param(t, rho);
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operator
    prox_tg = @(x) prox_g(x, t);

    %% Relative Error Calculations
    [f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    xk_old = xk;
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Primal Douglas-Rachford Splitting Algorithm
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