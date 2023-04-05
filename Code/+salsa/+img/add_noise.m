%% Purpose: Add Noise to Image using MATLAB imnoise
function J = add_noise(I, type, args, show)
    arguments 
        I    double
        type string {mustBeMember(type, ...
                                    {'gaussian',     ...
                                     'poisson',      ...
                                     'salt & pepper', ...
                                     'speckle', ...
                                     'none'})} = salsa.defaults.get_noise_def()
        args cell    = salsa.defaults.get_noise_def(type);
        show logical = true
    end
    %{
       %% imnoise options from MATLAB Doc
        J = imnoise(I,'gaussian',m,var_gauss):
            Gaussian white noise with mean m and variance var_gauss.

        J = imnoise(I,'poisson'):
            Poisson noise from the data instead of adding artificial 
            noise to the data.

        J = imnoise(I,'salt & pepper',d):
            salt and pepper noise, where d is the noise density. 
            This affects approximately d*numel(I) pixels.

        J = imnoise(I,'speckle',var_speckle):
            multiplicative noise using the equation J = I+n*I, 
            where n is uniformly distributed random noise with 
            mean 0 and variance of var_speckle.
    %} 
    
    %% Add Noise
    if strcmp(type, 'none')
        J = I;
    else
        J = imnoise(I, type, args{:});
    end
    
    %% Display Image
    if show
        fig_name = "Image after adding Noise";
        title_msg = "Using " + upper(type) + " imnoise Algorithm";
        salsa.img.display(J, fig_name, title_msg)
    end
end