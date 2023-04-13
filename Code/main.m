%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" subpackage of easter eggs 

%% Tune Algorithms
%{
    test_batch_tuning(file_path, algorithm, ...
                      problems, gammal1s, gammal2s, ...
                      arg1s, arg2s, ...
                      maxIters, sample_rate, ...
                      blur_type, blur_arg, ...
                      noise_type, noise_arg, ...
                      pad_type)
    Where,
    arg1s : t
    arg2s : pho | s
%}
% img_path = salsa.defaults.get_img_def("cameraman");
% 
% salsa.tests.test_batch_tuning(img_path, "admm", ...
%                               "l1", 0.06, 1.0,  ...
%                               1e-2*2, 1e-1*2)
% 
% salsa.tests.test_batch_tuning(img_path, "chambollepock", ...
%                               "l1", [0.06, 0.07], 1.0,  ...
%                               1e-1*2, 1e-1*2, ...
%                               10, 1)

%% --------------- Todo --------------------- %%
%{
    get_input_param_def : Choose which defualt values to pick based on
%}

%% --------------- Tests --------------------- %%
%% Testing Imgage Load + Blur + Noise + Display
% img_path = salsa.defaults.get_img_def("salsa_default");
% [kernel, b, bn] = salsa.tests.test_blur_and_noise(img_path, "gaussian", {}, "salt & pepper");

%% Testing Blur Noise Combinations
% save_figs = false;
% salsa.tests.test_blur_noise_combos(save_figs);

%% Testing Default Param Filler
% salsa.tests.test_default_input_param_completion()
   
%% Testing Prox 
% verbos = false;
% salsa.tests.test_all_prox(verbos);

%%  ---------- Spicy Command List --------- %%
%{
    salsa.spicy.disp_salsa_bottle()
    salsa.spicy.disp_salsa_error()
    salsa.spicy.spill_the_beans()
%}