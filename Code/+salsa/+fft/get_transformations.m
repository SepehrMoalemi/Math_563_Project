function [f_I_ATA, f_inv_I_ATA] = get_transformations(kernel, b, t)
    %% Constructing the K and D matrices
    % A = [K; D]
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

    %% Dx : R^(m x n)->2 concat. R^(m x n)
    f_D = @(x) cat(3, f_D1(x), f_D2(x));
    
    %% K'x, D1'x, D2'x : R^(m x n)->R^(m x n)
    f_K_T  = @(x) applyPeriodicConv2D(x, eig_K_T);
    f_D1_T = @(x) applyPeriodicConv2D(x, eig_D1_T);
    f_D2_T = @(x) applyPeriodicConv2D(x, eig_D2_T);

    %% D'y : 2 concat. R^(m x n)->R^(m x n)
    f_D_T = @(y) f_D1_T(y(:,:,1)) + f_D2_T(y(:, :, 2));

    %% (I + K'K + D'D)x : R^(m x n)->R^(m x n)
    % Notes: (I + A'A) = (I + K'K + D'D)
    f_I_ATA = @(x) x + f_K_T(f_K(x)) + f_D_T(f_D(x));
    
    %% Eigenvalues of I + t*t(K'K + D'D); 
    eigValsMat = ones(m, n) + t*t*(eig_K_T .*eig_K   + ...
                                   eig_D1_T.*eig_D1 + ...
                                   eig_D2_T.*eig_D2);

    %% (I + K'*K + D'*D)^(-1)*x : R^(m x n)->R^(m x n)
    f_inv_I_ATA = @(x) ifft2(fft2(x)./eigValsMat); 
end

%% Helper Functions
function out = applyPeriodicConv2D(x, eigValArr)
    %DESCRIPTION: For a given "unblurred" image x and the eigenvalue array for
    %the blurring kernel, computes the "blurred image" (e.g. Kx and Dx in the paper)
    %   INPUT:  x           = m x n matrix representing the image
    %           eigValArry  = m x n representing the eigenvalues of the 2D DFT
    %                         of the convolution kernel
    %   OUTPUT: out         = m x n the "blurred" image (i.e. Kx)
    %
    %MATH: Observe that K = Q^H eigValArry Q where Q is essentially the
    %discrete fourier transform and Q^H is the inverse fourier transform. This
    %perform Kx which reduces to this ifft(eigValArry.*fft(x)).
    out = ifft2(eigValArr.*fft2(x));
end

function eigValArry = eigValsForPeriodicConvOp(kernel, numRows, numCols)
    %DESCRIPTION: Computes the eigenvalues of the 2D DFT of the convolution kernel;
    %(Note this is an array of eigenvalues because numCols can be larger than).
    %
    %   INPUT:      kernel  = correlation kernel (e.g. fspecial('gaussian'))
    %               numRows = scalar; # of rows in the blurred image (b)
    %               numCols = scalar; # of columns in the blurred image (b)
    %   OUTPUT:     eigValArry = numRows x numCol matrix containing the
    %                           eigenvalues of the convolution kernel
    
    % Constructing the impulse: customary to put this in the upper left hand
    % corner pixel
    a = zeros(numRows, numCols);
    a(1,1) = 1;
    
    %Impulse Response from the given kernel
    % 'circular' for periodic boundary conditions
    Ra = imfilter(a, kernel, 'circular');
    
    %Fourier transform of the impulse response
    eigValArry = fft2(Ra);
end
