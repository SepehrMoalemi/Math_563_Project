function [xk, rel_err] = admm(prox_tf, prox_g, x, b, i)
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

    %% Get Prox g
    prox_tg = @(x) prox_g(x, i.tcp);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;
    uk = x.u0;
    wk = x.w0;

    maxIter = i.maxiter;
    t   = i.tcp;            % This value is 1/t
    rho = i.rho;

    fprintf('stepsize of 1/t = %G.\n', t);
    fprintf('==================================\n')

    %% ADMM Algorithm
    tic

    time = 0;
    sample_rate = i.sample_rate;

    indx = 1;
    rel_err = zeros(floor(maxIter/sample_rate),1);
    fprintf('Using Rel_Error = ||xk - xk_1||/||xk_1||\n')

    for k = 1:maxIter
        if mod(k, sample_rate) == 0
            time = toc - time;
            fprintf('[%d/%d]-[%G Sec/Iter]: ', k, maxIter,time/k);
            iter_rel_err = norm(xk_old - xk)/norm(xk_old);
            fprintf('Rel_Err = %0.2E\n',iter_rel_err);
            rel_err(indx) = iter_rel_err;
            indx = indx + 1;
        end

        xk_old = xk;

        xk = f_inv_I_ATA(uk + f_A_T(yk) - t*(wk + f_A_T(zk)));
        uk = prox_tf(rho*xk + (1 - rho)*uk + t*wk);
        yk = prox_tg(rho*f_A(xk) + (1 - rho)*yk + t*zk);
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);
    end
    fprintf('Total Elapsed Time: %f\n', toc);
end