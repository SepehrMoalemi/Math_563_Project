%% Purpose:Image De-blurring and De-noising
clc; clear; close;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" sub package of easter eggs 

%% Testing setting default input values
test_set_def_input = false;
if test_set_def_input
    i.maxiter = 69;
    i.tcp = 12;
    i = salsa.aux.default_param_completion(i);
end

%% Testing Image preprocessing
test_img_prepr = true;
if test_img_prepr
    dir_name   = "./test_images/";
    file_names = ["mcgill.jpg", "cameraman.jpg", "manWithHat.tiff"];
    
    % Load Image
    file_path = dir_name + file_names(1);
    I = img.load(file_path);
    
    % Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = true;
    I = img.pre_process(I, to_grayscale, resize, show_preproc);

    % Blur Image
    b = img.blur(I, "motion");
end

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