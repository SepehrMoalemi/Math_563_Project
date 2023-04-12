function [xk, rel_err] = admm(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end
  %{ 
    TO BE ADJUSTED: Add info on alg
  %}

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;
    uk = x.u0;
    wk = x.w0;

    t   = i.tadmm;           
    rho = i.rhoadmm;

    %% Print Params in use
    if i.verbos
        salsa.util.print_param(t, rho);
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_tg = @(x) prox_g(x, 1/t);
  
    %% Relative Error Calculations
    [f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    xk_old = xk;
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% ADMM Algorithm
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

        xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + wk/t);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + zk/t);
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);
    end
    xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end