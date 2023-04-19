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
        salsa.util.print_param(t, rho, x);
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operator
    prox_tg = @(x) prox_g(x, t);

    %% Relative Error Calculations
    [obj_fun, f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;
    plt_rate = floor(maxIter)/5;
    
    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Primal Douglas-Rachford Splitting Algorithm
    digits = numel(num2str(maxIter));
    pad = repmat(' ',1, 2*digits+4);

    if i.verbos
        fprintf('%sf_objective | Rel_Err_Val | Rel_Err_Opt\n',pad);
    end
    
    indx = 1;
    tic
    for k = 1:maxIter
        xk_old = xk;

        xk = prox_tf(z1);
        yk = prox_tg(z2);

        uk = f_inv_I_ATA(2*xk - z1 + f_A_T(2*yk - z2));
        
        vk = f_A(uk);
        z1 = z1 + rho*(uk - xk);
        z2 = z2 + rho*(vk - yk);

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
    xk = prox_tf(z1);
    if i.verbos
        salsa.util.print_completion(rel_err.val, obj_fun(xk), toc, i.spicy);
    end
end