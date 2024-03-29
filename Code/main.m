%% Purpose:Image De-blurring and De-noising
clc; clear; close all;

%% Usage
%{
    %% Solver Parameter struct i
        Where:
            i[struct]: Input Parameter
                (*) i.maxiter [int]: Iteration Limit
    
                (*) i.gammal1 [double]: Amount of De-noising in l1
                (*) i.gammal2 [double]: Amount of De-noising in l2
    
                (*) i.rhoprimaldr [double]: Relaxation Parameter rho in douglasrachfordprimal
                (*) i.tprimaldr   [double]: Stepsize t in douglasrachfordprimal
    
                (*) i.rhoprimaldualdr [double]: Relaxation Parameter rho in douglasrachfordprimaldual
                (*) i.tprimaldualdr   [double]: Stepsize t in douglasrachfordprimaldual
    
                (*) i.rhoadmm [double]: Relaxation Parameter pho in ADMM
                (*) i.tadmm   [double]: Stepsize t in ADMM
    
                (*) i.tcp [double]: stepsize for chambollepock
                (*) i.scp [double]: stepsize for chambollepock

                (*) *** For Extra Optional Parameters refer to end of Usage ***

            Ex) Specify your own values (empty field will be replaced by default values)
            % Set common input parameters for all algorithms
                i.maxiter = 500;
                i.gammal1 = 0.049;

            % Set default input parameters for primal douglas-rachford algorithm
                i.tprimaldr = 2.0;
                i.rhoprimaldr = 0.1;

            Ex) Use all default values provided at +salsa/+defaults/get_input_param_def.m
                by initializing with an empty struct
                i = struct();

    %% Initial Starting point struct x
        In addition to the starting point values of each algorithm, you can pass the original image, 
        I, using this struct. This enable error calculations using the true data.
        Ex) Specify your own values (empty field will be replaced by default values)
        % case "douglasrachfordprimal"
                [m, n] = size(Image);
                x.z1 = zeros(m, n);
                x.z2 = zeros(m,n,3);

        Ex) Use all default values provided at +salsa/+defaults/get_starting_point_def.m
            by initializing an empty struct
            x = struct();
        
    %% Provide Full File Path to Image : img_path      
        Ex) Give your own file path:
            img_path  = "./somedir/somesubdir/file.png";

        Ex) Pick a default image [cameraman, mcgill, manwithhat, salsa_default]:
            img_path = salsa.defaults.get_img_def("salsa_default");

    %% Apply Blur + Noise to Image
        Ex) Provide your own blur, noise types using:
            [I, kernel, b] = salsa.img.corrupt(img_path, ...
                                               blur_type, blur_arg, ...
                                               noise_type, noise_arg, ...
                                               pad_type)
        Where:
            blur_type = {'average', 'disk', 'gaussian', log', 'laplacian', 'motion'}
            blur_arg  = corresponding vals in cell format
                      = or pass {} to use defaults
            noise_type = {'gaussian', 'poisson', 'salt & pepper', 'speckle'}
            noise_arg  = corresponding vals in cell format
                       = or pass {} to use defaults
            pad_type = {'symmetric', 'replicate', 'circular'}

        Ex) Use defualt values:
            [I, kernel, b] = salsa.img.corrupt(img_path);

        Where, 
            Default Blur  : Motion {len = 15, theta = 0}
            Default Noise : Salt & Pepper {d = 0.1}

    %% Extra i struct options: Parameters for ploting and printing: 
        (*) i.sample_rate [int]: Output to screen frequency
        (*) i.verbos [logical]: Prints progress to terminal
    
        (*) i.plt_final [logical]: Plot final result
        (*) i.plt_progress [logical]: Plots deblurred image while iterating

        (*) i.plt_rel_err [logical]: Plot Error vs iterations
        (*) i.plt_diff [logical] : Plot difference Image between x_original and x_final
    
        NOTE: In addition to setting i.plt_rel_err to true, you can pass
        the original image, I, in the initial starting point struct, x, to
        calculate the error of:
                                |I - x_{k}|/|I| 
        Otherwise, the error would be:
                          |x_{k} - x_{k-1}|/|x_{k}|
        Ex)
            x.I = I;
            i.plt_rel_err = true;
        
        NOTE: For using plt_diff, you need to pass the original image, I,
        in the initial starting point struct, x, similar to above.

    %% Extra i struct options: Easter egg options
        (*) i.spicy [logical]: Activates a Subpackage of easter eggs 

         The spicy subpackage consists of:
            1) disp_salsa_bottle.m
                Used to display our welcome message!

            2) disp_salsa_error.m
                Used to output a special error message incase an algorithm
                diverges!

            3) spill_the_beans.m
                Fun creative food related receipes generated by ChatGPT

            4) stewchastic.m
                Highly sophisticated Stochastic Solver

            To use one of the first 3 functions, try:
                salsa.spicy.function_name()
            Ex) salsa.spicy.spill_the_beans()

            To use the stewchastic solver, choose it as a solver like
            below:
                x_final = salsa.solver("l1","stewchastic", x, kernel, b, i);

    %% Call Solver
        problem : Choice of Norm in the Optimization Function ['l1' | 'l2']
                
        algorithm : Optimization Algorithm ['douglasrachfordprimal'     |
                                            'douglasrachfordprimaldual' |
                                            'admm'                      |
                                            'chambollepock'             |
                                            'stewchastic']
        Ex)
            x_final = salsa.solver("l1","stewchastic", x, kernel, b, i);
%}

%% Solver Parameter struct i
i = struct();                                   % Passing Empty struct so solver uses default values

%% Initial Starting point struct x 
x = struct();                                   % Passing Empty struct so solver uses default values

%% Provide Full File Path to Image
img_path = salsa.defaults.get_img_def("cameraman");

%% Apply Blur + Noise to Image
[I, kernel, b] = salsa.img.corrupt(img_path);   % Using default motion blur + salt & pepper noise

%% Extra i struct options: Parameters for ploting and printing error:
x.I = I;                                        % Store Original Image for Error Calculations

i.verbos = true;                                % Print Progress

i.plt_final    = true;                          % Display Final Image
i.plt_progress = true;                          % Display Progress Images (linspaced 5 times)
i.plt_rel_err  = true;                          % Plot Error vs Iterations
i.plt_diff     = true;                          % Display Difference Image

%% Extra i struct options: Easter egg options
i.spicy = true;                                 % Enable Easter eggs

%% Call Solver
x_final = salsa.solver("l1","stewchastic", x, kernel, b, i);