%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" subpackage of easter eggs 

%% Testing Algorithms
img_path = salsa.defaults.get_img_def("salsa_default");
% salsa.tests.test_chambollepock(img_path)
% salsa.tests.test_douglasrachfordprimal(img_path)
salsa.tests.test_primaldual(img_path)

%% --------------- Todo --------------------- %%
%{
    get_input_param_def : Choose which defualt values to pick
    
%}

%% --------- Questions for Prof ------------- %%
%{
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
