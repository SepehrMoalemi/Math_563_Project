%% Purpose: Get Default Args for MATLAB fspecial
function args = get_blurring_def(type)
    arguments 
        type string {mustBeMember(type, ...
                                    {'default', ...
                                     'average',  ...
                                     'disk',     ...
                                     'gaussian'  ...
                                     'log'       ...
                                     'laplacian' ...
                                     'motion'})} = 'default'
    end
    switch type
        % Return Default bluring type
        case 'default'
            args = 'motion';

        % fspecial('average',hsize)
        case 'average'
            args = {[3, 3]};

        % fspecial('disk',radius)
        case 'disk'
            args = {5};
    
        % fspecial('gaussian',hsize,sigma)
        case 'gaussian'
            args = {[3, 3], 0.5};
    
        % fspecial('laplacian',alpha)
        case 'laplacian'
            args = {0.2};
    
        % fspecial('log',hsize,sigma)
        case 'log'
            args = {[5, 5], 0.5};
    
        % fspecial('motion',len,theta)
        case 'motion'
            args = {15, 0};    
    end
end