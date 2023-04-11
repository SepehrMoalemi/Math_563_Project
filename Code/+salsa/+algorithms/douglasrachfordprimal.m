%% Purpose: Primal Douglas-Rachford Splitting
function [xk, rel_err] = douglasrachfordprimal(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf function_handle
        prox_g  function_handle
        x       struct
        b       double
        i       struct
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
    
    %% Primal Douglas-Rachford Splitting Algorithm
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