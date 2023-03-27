%% Purpose: Blur Image using MATLAB fspecial
function b = blur(I, type)
    arguments 
        I double
        type string {mustBeMember(type, ...
                                    {'average', ...
                                     'disk', ...
                                     'gaussian' ...
                                     'log' ...
                                     'laplacian' ...
                                     'motion'})}
    end
    %{
       %% fspecial options 
        h = fspecial('average',hsize)
        h = fspecial('disk',radius)
        h = fspecial('gaussian',hsize,sigma)
        h = fspecial('log',hsize,sigma)
        h = fspecial('laplacian',alpha)
        h = fspecial('motion',len,theta)
    %} 
    
    %% Perform 2-D filtering to blur
    % Get Defaul Options based on type
    args = img.defaults.get_blurring_def(type);
    b = imfilter(I, fspecial(type, args{:}));
end

