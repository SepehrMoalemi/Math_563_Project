function [ out ] = applyPeriodicConv2D( x, eigValArr )
%DESCRIPTION: For a given "unblurred" image x and the eigenvalue array for
%the blurring kernel, computes the "blurred image" (e.g. Kx and Dx in the
%paper)
%   INPUT:  x           = m x n matrix representing the image
%           eigValArry  = m x n representing the eigenvalues of the 2D DFT
%                       of the convolution kernel
%   OUTPUT: out         = m x n the "blurred" image (i.e. Kx)
%
%MATH: Observe that K = Q^H eigValArry Q where Q is essentially the
%discrete fourier transform and Q^H is the inverse fourier transform. This
%perform Kx which reduces to this ifft(eigValArry.*fft(x)).



out = ifft2(eigValArr.*fft2(x));
end

