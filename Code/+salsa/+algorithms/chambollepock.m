%% Purpose: Chambolle-Pock Method
function [xk, rel_err] = chambollepock(prox_tf, prox_g, x, b, i)
    %{
        solves the generic convex optimization problem:
                min f(x) + g(y)
                x,y
            subject to Ax = y
        by finding the solutions (x^hat, y^hat) of the 
        saddle point problem:
                min max <Ax,y> + f(x) - g^*(y)
                 x   y
        Where A = [K D]'
        convergence is garunteed for s*t*(||A||^2) < 1
    %}
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

    t = i.tcp; 
    s = i.scp;

    %% Print Params in use
    if i.verbos
        salsa.util.print_param(t, s, x);
    end

    %% Get fft Transformations
    [f_A, f_A_T, ~, ~] = salsa.fft.get_transformations(i.kernel, b);

    %% Proximal Operators
    prox_sgc = @(x) salsa.prox_lib.conjProx(prox_g, x, i.scp);

    %% Relative Error Calculations
    [obj_fun, f_val_err, f_opt_err] = salsa.util.rel_err_fun(x, b, f_A, i);
    
    maxIter = i.maxiter;

    sample_rate = i.sample_rate;
    plt_rate = floor(maxIter)/5;

    rel_err.val = zeros(floor(maxIter/sample_rate),1);
    rel_err.opt = zeros(floor(maxIter/sample_rate),1);

    %% Chambolle-Pock Algorithm
    digits = numel(num2str(maxIter));
    pad = repmat(' ',1, 2*digits+4);

    if i.verbos
        fprintf('%sf_objective | Rel_Err_Val | Rel_Err_Opt\n',pad);
    end
    
    indx = 1;
    tic
    for k = 1:maxIter
        xk_old = xk;

        yk = prox_sgc(yk + s*f_A(zk));
        xk = prox_tf(xk - t*f_A_T(yk));
        zk = 2*xk - xk_old;

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
    if i.verbos
        salsa.util.print_completion(rel_err.val, obj_fun(xk), toc, i.spicy);
    end
end