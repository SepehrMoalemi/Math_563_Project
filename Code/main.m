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
% salsa.test.test_l2_sq_Prox();
% salsa.test.test_isoProx();
% salsa.test.test_conjProj_l2();

%% Testing Algorithms
file_path  = "./test_images/cameraman.jpg";
blur_type  = "motion";
noise_type = "gaussian";
pad_type   = "circular";

show_raw = false;
I = img.load(file_path, show_raw);

% Apply Preprocessing
to_grayscale = true; 
resize       = true;
show_preproc = false;
I = img.pre_process(I, to_grayscale, resize, show_preproc);

% Blur Image
[kernel, b] = img.add_blur(I, blur_type, pad_type);

% Add Noise
b = img.add_noise(b, noise_type);        

% Set initial conditions
[m, n] = size(b);

% Noise smoothing
i.gammal1 = 3;                         
i.gammal2 = 3;                         

% --------------------- Algorithms --------------------- % 
    % --------------- chambollepock ------------------ %
%     x.x0 = b;
%     x.y0 = zeros(m,n,3);
%     x.z0 = b;
%     
%     Set parameters
%     i.maxiter = 5*1e2;
%     i.tcp = 1e-2;
%     i.scp = 1e-2;
% 
%     x_out = salsa("l2","chambollepock",x,kernel,b,i);

    % ------ Primal Douglas-Rachford Splitting ------ %
%     x.z1 = b;
%     x.z2 = zeros(m,n,3);
%     
%     % Set parameters
%     i.maxiter    = 2*1e2;
%     i.tprimaldr   = 1e-4; 
%     i.rhoprimaldr = 1e-1;
% 
%     x_out = salsa("l2","douglasrachfordprimal",x,kernel,b,i);

    % ------ Primal-Dual Douglas-Rachford Splitting ------ %
    
    x.p0 = b;
    x.q0 = zeros(m,n,3);

    % Set parameters
    i.gammal1 = 1.1;
    i.maxiter = 2*1e2;
    i.tprimaldualdr = 5e-2;
    i.rhoprimaldualdr = 0.5;

    x_out = salsa("l1","douglasrachfordprimaldual",x,kernel,b,i);

    % --------------- admm ------------------ %
    % x.x0 = b;
    % x.y0 = zeros(m,n,3);
    % x.z0 = zeros(m,n,3);
    % x.u0 = b;
    % x.w0 = b;
    % 
    % % Set parameters
    % i.maxiter = 5*1e2;
    % i.tcp = 1e-2;        % Note that this value is 1/t
    % i.rho = 0.8;
    % 
    % i.gammal1 = 0.1;                         
    % i.gammal2 = 3;  
    % 
    % x_out = salsa("l1","admm",x,kernel,b,i);

% --------------------- Plot Deblurred --------------------- %
fig = figure('Name','Deblurred Image' );
imshow(x_out,[])

% fig = figure('Name','Diff Image' );
% imshow(imabsdiff(x_out,I),[])

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