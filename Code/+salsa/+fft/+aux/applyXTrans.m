function [xtw] = applyXTrans(w, x, kernel_size)
    %   w \in \R^(256 x 256);
    %   x \in \R^(256 x 256);
    %   kernel_size = length of one side;
    %output xtw = X^Tw
    % (X^Tw)_(ij) = < w, conv2(x, impulse at the ij entry, 'same') >
    im = zeros(kernel_size);
    xtw = im;
    for i = 1:kernel_size
        for j = 1:kernel_size
            shift_im      = im;
            shift_im(i,j) = 1;
            xtw(i,j)      = sum(sum(w.*conv2(x, shift_im, 'same')));
        end
    end
end

