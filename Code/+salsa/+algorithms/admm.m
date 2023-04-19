%% Purpose: ADMM Algorithm
function [xk, rel_err] = admm(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf     function_handle
        prox_g      function_handle
        x           struct
        b           double
        i           struct
    end

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
        salsa.util.print_param(t, rho, x);
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_tg = @(x) prox_g(x, 1/t);
  
    %% Relative Error Calculations
    [obj_fun, f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;
    plt_rate = floor(maxIter)/5;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% ADMM Algorithm
    digits = numel(num2str(maxIter));
    pad = repmat(' ',1, 2*digits+4);

    if i.verbos
        fprintf('%sf_objective | Rel_Err_Val | Rel_Err_Opt\n',pad);
    end
    
    indx = 1;
    tic
    for k = 1:maxIter
        xk_old = xk;

        xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + wk/t);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + zk/t);
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);

        if i.verbos && mod(k, sample_rate) == 0
            rel_err.val(indx) = f_val_err(xk, xk_old);
            rel_err.opt(indx) = f_opt_err(xk, xk_old);
            f_obj = obj_fun(xk);
            fprintf(['[%',num2str(digits),'d/%d]: '], k, maxIter);
            fprintf('%9.2E  |',f_obj);
            fprintf('%11.2E  |',rel_err.val(indx));
            fprintf('%10.2E\n',rel_err.opt(indx));
            indx = indx + 1;
        end

        if i.plt_progress && mod(k, plt_rate) == 0
            salsa.img.display(xk, "Image after " + num2str(k) + " Iterations");
        end
    end
    xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
    if i.verbos
        salsa.util.print_completion(rel_err.val, obj_fun(xk), toc, i.spicy);
    end
end