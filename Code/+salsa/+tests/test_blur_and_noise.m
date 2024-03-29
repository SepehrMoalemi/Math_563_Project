function [kernel, b, bn] = test_blur_and_noise(file_path, ...
                                               blur_type, blur_arg, ...
                                               noise_type, noise_arg, ...
                                               pad_type, ...
                                               show)
    arguments
        file_path char {mustBeFile(file_path)}
        blur_type string {mustBeMember(blur_type, ...
                                        {'average',  ...
                                         'disk',     ...
                                         'gaussian'  ...
                                         'log'       ...
                                         'laplacian' ...
                                         'motion'})} = salsa.defaults.get_blurring_def()
        blur_arg cell = {}
        noise_type string {mustBeMember(noise_type, ...
                                        {'gaussian',     ...
                                         'poisson',      ...
                                         'salt & pepper' ...
                                         'speckle'})} = salsa.defaults.get_noise_def()
        noise_arg cell = {}
        pad_type string {mustBeMember(pad_type, ...
                                        {'symmetric', ...
                                         'replicate', ...
                                         'circular'})} = salsa.defaults.get_filter_def()
        show struct = struct('raw',    true, ...
                             'preproc',true, ...
                             'blured', true, ...
                             'noise',  true)
    end

    % Load Image
    I = salsa.img.load(file_path, show.raw);
    
    % Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    I = salsa.img.pre_process(I, to_grayscale, resize, show.preproc);

    % Blur Image
    [kernel, b] = salsa.img.add_blur(I, blur_type, blur_arg, pad_type, show.blured);

    % Add Noise
    bn = salsa.img.add_noise(b, noise_type, noise_arg, show.noise);
end