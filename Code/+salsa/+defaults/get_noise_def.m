%% Purpose: Get Default Args for MATLAB fspecial
function args = get_noise_def(type)
    arguments 
        type string {mustBeMember(type, ...
                                    {'default',      ...
                                     'gaussian',     ...
                                     'poisson',      ...
                                     'salt & pepper' ...
                                     'speckle'})} = 'default'
    end
    switch type
        % Return Default noise type
        case 'default'
            args = 'salt & pepper';
            
        % J = imnoise(I,'gaussian',m,var_gauss)
        case 'gaussian'
            args = {0, 0.001};

        % J = imnoise(I,'poisson')
        case 'poisson'
            args = {};
    
        % J = imnoise(I,'salt & pepper',d)
        case 'salt & pepper'
            args = {0.1};
    
        % J = imnoise(I,'speckle',var_speckle)
        case 'speckle'
            args = {0.01}; 
    end
end