%% Purpose: Get Default Args for MATLAB fspecial
function args = get_noise_def(type)
    arguments 
        type string {mustBeMember(type, ...
                                    {'gaussian',     ...
                                     'poisson',      ...
                                     'salt & pepper' ...
                                     'speckle'})}
    end
    switch type
        % J = imnoise(I,'gaussian',m,var_gauss)
        case 'gaussian'
            args = {0, 0.01};

        % J = imnoise(I,'poisson')
        case 'poisson'
            args = {};
    
        % J = imnoise(I,'salt & pepper',d)
        case 'salt & pepper'
            args = {0.05};
    
        % J = imnoise(I,'speckle',var_speckle)
        case 'speckle'
            args = {0.05}; 
    end
end