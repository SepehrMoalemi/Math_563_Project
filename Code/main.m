%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" sub package of easter eggs 

%% Testing Prox 
salsa.test.test_all_prox(false);
   
%% Testing Algorithms
% salsa.test.test_chambollepock('./test_images/cameraman.jpg')
salsa.test.test_douglasrachfordprimal('./test_images/cameraman.jpg')

%salsa.test.test_primaldual('./test_images/cameraman.jpg')

%% TODO
%{
    get_input_param_def : Choose which defualt values to pick
    test_conjProj_l2()  : Implement test 
%}

%% Spicy Command List
%{
    salsa.spicy.disp_salsa_bottle()
    salsa.spicy.disp_salsa_error()
    salsa.spicy.spill_the_beans()
%}

%% Questions for Prof
%{
%}

%% Changes since last commit
%{
    Added offset support for l1 and l2 prox
    Changed prox_g to use the offset
    Added logical check for the prox tests
    Implemented a test all prox that throws an error if a prox is incorrect
%}