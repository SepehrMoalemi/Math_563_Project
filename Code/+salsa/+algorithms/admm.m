function [xk, rel_err] = admm(prox_tf, prox_g, x, b, i)
    arguments
        prox_tf function_handle
        prox_g  function_handle
        x       struct
        b       double
        i       struct
    end
  %{ 
TO BE ADJUSTED
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

    %% Get fft Transformations
    [f_A, f_A_T, ~, f_inv_I_ATA] = salsa.fft.get_transformations(i.kernel, b);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;
    uk = x.u0;
    wk = x.w0;

    maxIter = i.maxiter;
    t   = i.tcp;           
    rho = i.rho;

    %% Get Prox g
    prox_tg = @(x) prox_g(x, 1/t);

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

    %% ADMM Algorithm
    tic

    time = 0;
    sample_rate = i.sample_rate;

    indx = 1;
    rel_err = zeros(floor(maxIter/sample_rate),1);

    for k = 1:maxIter
        if mod(k, sample_rate) == 0  && i.verbos
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);
            iter_rel_err = f_err(xk, xk_old);
        fprintf('Rel_Err = %0.2E\n',iter_rel_err);
            rel_err(indx) = iter_rel_err;
            indx = indx + 1;
        end

        xk_old = xk;

<<<<<<< HEAD
        xk = f_inv_I_ATA(uk + f_A_T(yk) - 1/t*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + 1/t*wk);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + 1/t*zk);
=======
        xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + wk/t);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + zk/t);
>>>>>>> d0ee1d90ba5f005ba1f8637802e9b8c9640e3743
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);
    end
    xk = f_inv_I_ATA(uk + f_A_T(yk) - (1/t)*(wk + f_A_T(zk)));
    if i.verbos
        fprintf('Total Elapsed Time: %f\n', toc);
    end
end