function [KD_transf, inv_KD_transf] = get_transformations(kernel, b, t)
    %% Constructing the K and D matrices
    [m, n] = size(b);
    
    %% Compute Eignevalue Matrices of K, D1, D2
    % D1 = I  oplus D
    % D2 = D  oplus I
    eig_K  = eigValsForPeriodicConvOp(kernel,  m, n);
    eig_D1 = eigValsForPeriodicConvOp([-1,1]', m, n);
    eig_D2 = eigValsForPeriodicConvOp([-1,1],  m, n);
    
    %% Compute Eignevalue Matrices of K^T, D1^T, D2^T
    eig_K_T  = conj(eig_K);
    eig_D1_T = conj(eig_D1);
    eig_D2_T = conj(eig_D2);

    %% Kx, D1x, D2x : R^(m x n)->R^(m x n)
    f_K  = @(x) applyPeriodicConv2D(x, eig_K);
    f_D1 = @(x) applyPeriodicConv2D(x, eig_D1);
    f_D2 = @(x) applyPeriodicConv2D(x, eig_D2);
    
    %% K^Tx, D1^Tx, D2^Tx : R^(m x n)->R^(m x n)
    f_K_T  = @(x) applyPeriodicConv2D(x, eig_K_T);
    f_D1_T = @(x) applyPeriodicConv2D(x, eig_D1_T);
    f_D2_T = @(x) applyPeriodicConv2D(x, eig_D2_T);
    
    %% Dx : R^(m x n)->2 concat. R^(m x n)
    f_D = @(x) cat(3, f_D1(x), f_D2(x));

    %% D^Ty : 2 concat. R^(m x n)->R^(m x n)
    applyDTrans = @(y) f_D1_T(y(:,:,1)) + f_D2_T(y(:, :, 2));

    %% (I + K^TK + D^TD)x : R^(m x n)->R^(m x n)
    KD_transf = @(x) x + f_K_T(f_K(x)) + applyDTrans(f_D(x));
    
    %% Eigenvalues of I + t*t*K^TK + t*t*D^TD; 
    eigValsMat = ones(m, n) + t*t*(eig_K_T.*eig_K   + ...
                                   eig_D1_T.*eig_D1 + ...
                                   eig_D2_T.*eig_D2);

    %% (I + K^T*K + D^T*D)^(-1)*x : R^(m x n)->R^(m x n)
    inv_KD_transf = @(x) ifft2(fft2(x)./eigValsMat); 
end

