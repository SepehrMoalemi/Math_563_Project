function [eigValArry] = eigValsForPeriodicConvOp(kernel, numRows, numCols)
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

