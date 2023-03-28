function [ xtw ] = K_applyXTrans( w, x, kernelsize  )
%UNTITLED Summary of this function goes here
%   w \in \R^(256 x 256);
%   x \in \R^(256 x 256);
%   kernelsize = length of one side;

%output xtw = X^Tw

% (X^Tw)_(ij) = < w, conv2(x, impulse at the ij entry, 'same') >

    im = zeros(kernelsize);
    xtw = im;

    for i = 1:kernelsize
        for j = 1:kernelsize
            shift_im = im;
            shift_im(i,j) = 1;
            xtw(i,j) = sum(sum(w.*conv2(x, shift_im, 'same')));
        end
    end
    
end

