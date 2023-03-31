%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Parameters
spicy = false;  %Spicy activates the "./+salsa/+spicy" sub package of easter eggs 

%% Testing setting default input values
% salsa.test.test_default_input_param_completion()

%% Testing Image preprocessing
% [kernel, b, J] = img.test.test_blur_and_noise("./test_images/cameraman.jpg", ...
%                                               "gaussian", ...
%                                               "salt & pepper", ...
%                                               "circular");

%% Testing Prox
% salsa.test.test_boxProx();
% salsa.test.test_l1Prox();
% salsa.test.test_l2Prox();
% salsa.test.test_isoProx();

%% Testing Algorithms
file_path  = "./test_images/cameraman.jpg";
blur_type  = "motion";
noise_type = "gaussian";
pad_type   = "circular";

show_raw = true;
I = img.load(file_path, show_raw);

% Apply Preprocessing
to_grayscale = true; 
resize       = true;
show_preproc = false;
I = img.pre_process(I, to_grayscale, resize, show_preproc);

% Blur Image
[kernel, b] = img.add_blur(I, blur_type, pad_type);

% Add Noise
% b = img.add_noise(b, noise_type);

% Set initial conditions
[m, n] = size(b);

x.x0 = b;
x.y0 = zeros(m,n,3);
x.z0 = b;

% Set parameters
i.gammal1 = 1e-10;
i.maxiter = 5*1e2;
i.tcp = 1e-3;
i.scp = 1e-3;

x_out = salsa("l1","chambollepock",x,kernel,b,i);

fig = figure('Name','Deblurred Image' );
imshow(x_out,[])

fig = figure('Name','Diff Image' );
imshow(imabsdiff(x_out,I),[])

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
    Dimmensions of input/putput of transpose K and D
    isoProx confusion: (uk, vk) = ak but ak is scalar
    How is x_initial inputed? sometimes we expect upto 3 x_initials.
        - Do we expect correct dims for x_initial? Should we throw error
        (no need)
        - Should we have default x_initial (have default)
%}