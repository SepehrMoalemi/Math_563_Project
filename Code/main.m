%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" sub package of easter eggs 

%% Testing setting default input values
test_set_def_input = false;
if test_set_def_input
    i.maxiter = 69;
    i.tcp = 12;
    i = salsa.aux.default_input_param_completion(i);
end

%% Testing Image preprocessing
test_img_prepr = false;
if test_img_prepr
    dir_name   = "./test_images/";
    file_names = ["mcgill.jpg", "cameraman.jpg", "manWithHat.tiff"];
    
    % Load Image
    file_path = dir_name + file_names(2);
    show_raw = true;
    I = img.load(file_path, show_raw);
    
    % Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = false;
    I = img.pre_process(I, to_grayscale, resize, show_preproc);

    % Blur Image
    [kernel, b] = img.add_blur(I, "motion", "circular");

    % Add Noise
    J = img.add_noise(b, "salt & pepper");
end

%% Testing boxProx
test_box_prox = true;
if test_box_prox
    % random matrix size mxn in interval (a,b)
    m = 5; n = 1;
    a = -2; b = 4;
    x = a + (b-a).*rand(m, n)

    % Get boxProx 
    l = 0; u = 1;
    prox_x = salsa.aux.boxProx(x, l, u)
    
    % Find min sol using matlab
    fun = @(y) norm(x - y);
    lb = l*ones(m,n); ub = u*ones(m,n);
    x_opt = fmincon(fun,x,[],[],[],[],lb,ub)

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