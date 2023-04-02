function xk = admm(prox_f, prox_g, x, b, i)
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

    % prox_g = @(x) prox_g('admm', b, i, x, i.tcp);

    %% Initialize
    xk = x.x0; 
    zk = x.z0;
    yk = x.y0;
    uk = x.u0;
    wk = x.w0;

    maxIter = i.maxiter;
    t = i.tcp;            % This value is 1/t
    rho = i.rho;

    fprintf('stepsize of 1/t = %G.\n', t);
    fprintf('==================================\n')

    %% ADMM Algorithm
    for k = 1:maxIter
        if mod(k, 100) == 0
            fprintf('Iteration %d/%d : ', k, maxIter);
            fprintf('||xk - xk_1||/||xk_1|| = %G\n',norm(xk_old - xk)/norm(xk_old))
        end
        if mod(k, 500) == 0
            fprintf("Start Denoising \n");
            i.gammal1 = 3;
        end
        xk_old = xk;

        xk = f_inv_I_ATA(uk + f_A_T(yk) - t*(wk + f_A_T(zk)));
        uk = prox_f(rho*xk + (1 - rho)*uk + t*wk);
        yk = prox_g(rho*f_A(xk) + (1 - rho)*yk + t*zk, i.tcp, i);
        wk = wk + t*(xk - uk);
        zk = zk + t*(f_A(xk) - yk);
      
    end
end