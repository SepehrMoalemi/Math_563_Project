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
img_path = salsa.defaults.get_img_def("cameraman");

%{ ----------------------------- ADMM ----------------------------- }%
% salsa.tests.test_batch_tuning(img_path, "admm", ...
%                               "l1", 0.06, 1.0,  ...
%                               1e-2*2, 1e-1*2)

%{ -------------------------- Chambollepock ----------------------- }%
salsa.tests.test_batch_tuning(img_path, "chambollepock", ...
                              "l1", [0.03, 0.06], 0.0,  ...
                              0.2, 0.9, ...
                              100, 10, ...
                              "motion",{}, ...
                              "salt & pepper", {})

%{ --------------------------- Primal Dual ------------------------- }%
  %Graph no noise
% salsa.tests.test_batch_tuning(img_path, "douglasrachfordprimaldual", ...
%                               "l1", 0.000001, 1.0,  ...
%                               1e0*[1,5,10], 1e-1*3, 500, 10, 'motion', ...
%                               {}, 'none', {}, 'circular')
%                           
% salsa.util.next()
                          
  % Graphs different gammas
% salsa.tests.test_batch_tuning(img_path, "douglasrachfordprimaldual", ...
%                               "l1", [0.01, 0.02, 0.03], 1.0,  ...
%                               1e0*5, 1e-1*3)
%                           
% salsa.util.next()

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
% n = 110;
% digits = numel(num2str(n));
% for i=1:10:n
%     fprintf(['%',num2str(digits),'d\n'], i);
% end
