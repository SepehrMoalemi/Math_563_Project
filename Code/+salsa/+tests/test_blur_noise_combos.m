%% Purpose: Generate Combinations of Blur + Noise
function test_blur_noise_combos(save_figs)
    arguments
        save_figs logical = false
    end

    %% Grid
    blur_types  = {'average','disk','gaussian','log','laplacian','motion'};
    noise_types = {'gaussian','poisson','salt & pepper','speckle'};
    pad_type = 'circular';
    blur_arg  = {};
    noise_arg = {};

    %% Load Image File
    img_path = salsa.defaults.get_img_def();

    %% Generate Combinations
    show  = struct('raw',    false, ...
                   'preproc',false, ...
                   'blured', true, ...
                   'noise',  true);
    for blur_type = blur_types
        for noise_type = noise_types
            % Load Image
            I = salsa.img.load(img_path, show.raw);
            
            % Apply Preprocessing
            to_grayscale = true; 
            resize       = true;
            I = salsa.img.pre_process(I, to_grayscale, resize, show.preproc);
        
            % Blur Image
            [~, b] = salsa.img.add_blur(I, blur_type, blur_arg, pad_type, show.blured);
            if save_figs
                plt_blur_name = blur_type+"_"+pad_type;
                dir_blur = "./Results/Blurring/";
                salsa.util.mkdir_if_no_dir(dir_blur)
                saveas(gcf,dir_blur+plt_blur_name+".png")
            end
        
            % Add Noise
            salsa.img.add_noise(b, noise_type, noise_arg, show.noise);
            if save_figs
                plt_img = plt_blur_name+"_"+noise_type;
                dir_noise = "./Results/Noise/";
                salsa.util.mkdir_if_no_dir(dir_noise)
                saveas(gcf,dir_noise+plt_img+".png")
            end
        end
    end
end