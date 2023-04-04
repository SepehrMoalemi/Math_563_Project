%% Purpose: Blur Image using MATLAB fspecial
function [kernel, b] = add_blur(I, type, padding, show)
    arguments 
        I    double
        type string {mustBeMember(type, ...
                                    {'average',  ...
                                     'disk',     ...
                                     'gaussian'  ...
                                     'log'       ...
                                     'laplacian' ...
                                     'motion' ...
                                     'none'})}
        padding string {mustBeMember(padding, ...
                                    {'symmetric', ...
                                     'replicate', ...
                                     'circular'})} = img.defaults.get_filter_def()
        show logical = true
    end
    %{
       %% fspecial options from MATLAB Doc
        h = fspecial('average',hsize):
            averaging filter h of size hsize.

        h = fspecial('disk',radius):
            circular averaging filter (pillbox) within 
            the square matrix of size 2*radius+1

        h = fspecial('gaussian',hsize,sigma):
            otationally symmetric Gaussian lowpass filter 
            of size hsize with standard deviation sigma.

        h = fspecial('log',hsize,sigma):
            rotationally symmetric Laplacian of Gaussian 
            filter of size hsize with standard deviation sigma.

        h = fspecial('laplacian',alpha):
             3-by-3 filter approximating the shape of the 
             two-dimensional Laplacian operator, alpha 
             controls the shape of the Laplacian.

        h = fspecial('motion',len,theta):
            filter to approximate, once convolved with an 
            image, the linear motion of a camera. len specifies 
            the length of the motion and theta specifies the angle 
            of motion in degrees in a counter-clockwise direction. 
            The filter becomes a vector for horizontal and vertical motions. 
            The default len is 9 and the default theta is 0, which corresponds 
            to a horizontal motion of nine pixels.
    %} 
    
    %% Perform 2-D filtering to blur
    % Get Defaul Options based on type
    
    if strcmp(type, 'none')
        b = I;
        kernel = eye(3);
    else
        args = img.defaults.get_blurring_def(type);
        kernel = fspecial(type, args{:});
        b = imfilter(I, kernel, padding);
    end
    
    %% Display Image
    if show
        fig_name = "Image after Blurring";
        title_msg = "Using " + upper(type) + " Blurring Algorithm";
        img.display(b, fig_name, title_msg)
    end
end

