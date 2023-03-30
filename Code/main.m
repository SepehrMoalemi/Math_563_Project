%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" sub package of easter eggs 

%% Testing setting default input values
salsa.test.test_default_input_param_completion()

%% Testing Image preprocessing
[kernel, b, J] = img.test.test_blur_and_noise("./test_images/cameraman.jpg", ...
                                              "gaussian", ...
                                              "salt & pepper", ...
                                              "circular");

%% Testing Prox
% salsa.test.test_boxProx();
% salsa.test.test_l1Prox();
% salsa.test.test_l2Prox();

%% TODO
%{
    +salsa/+defaults/get_input_param_def : Choose which defualt values to pick
%}

%% Spicy Command List
%{
    salsa.spicy.disp_salsa_bottle()
    salsa.spicy.disp_salsa_error()
    salsa.spicy.spill_the_beans()
%}

%% Questions for Prof
%{
    Typo in (I+A'A)^-1: s should b t
    Dimmensions of input/putput of transpose K and D
    How to do Ax, How to do A'x: Confused with the dims
    isoProx confusion: (uk, vk) = ak but ak is scalar
    Prox on matrix but suppose to be a vector
    How is x_initial inputed? sometimes we expect upto 3 x_initials.
        - Do we expect correct dims for x_initial? Should we throw error
        - Should we have default x_initial
%}