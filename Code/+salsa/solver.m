%% Purpose: Interface for the SALSA package
function x_final = solver(problem, algorithm, x, kernel, b, i)
    arguments
        problem   (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        algorithm (1,:) char {mustBeMember(algorithm, ...
                                            {'douglasrachfordprimal', ...
                                             'douglasrachfordprimaldual', ...
                                             'admm', ...
                                             'chambollepock', ...
                                             'stewchastic'})}
        x      struct
        kernel double
        b      double
        i      struct = salsa.defaults.get_input_param_def(problem, algorithm)
    end
    %{ 
        x_final = salsa('problem', 'algorithm', x_initial, kernel, b, i)
    
        %% problem [char]: Choice of Norm in the Optimization Function
            OPTIONS: ['l1' | 'l2']
        
        %% algorithm [char]: Optimization Algorithm  
            OPTIONS: ['douglasrachfordprimal'     |
                      'douglasrachfordprimaldual' |
                      'admm'                      |
                      'chambollepock'             |
                      'stewchastic']
    
        %% x_initial[struct]: Initial Iterate
    
        %% kernel[(:,:) double]: Convolution Kernel (refer to fspecial)
    
        %% b[(:,:) double]: Bluered and Noisy Image
    
        %% i[struct]: Input Parameter
            Optional fields: 
            (*) maxiter [int]: Iteration Limit

            (*) gammal1 [double]: Amount of De-noising in l1
            (*) gammal2 [double]: Amount of De-noising in l2

            (*) rhoprimaldr [double]: Relaxation Parameter rho in douglasrachfordprimal
            (*) tprimaldr   [double]: Stepsize t in douglasrachfordprimal

            (*) rhoprimaldualdr [double]: Relaxation Parameter rho in douglasrachfordprimaldual
            (*) tprimaldualdr   [double]: Stepsize t in douglasrachfordprimaldual

            (*) rhoadmm [double]: Relaxation Parameter pho in ADMM
            (*) tadmm   [double]: Stepsize t in ADMM

            (*) tcp [double]: stepsize for chambollepock
            (*) scp [double]: stepsize for chambollepock

            (*) sample_rate [int]: Output to screen frequency
            (*) verbos [logical]: Print to terminal or not

            (*) plt_final [logical]: Plot final result
            (*) plt_progress [logical]: Plots deblurred image while iterating
            (*) plt_rel_err [logical]: Plot Error vs iterations
            (*) i.plt_diff [logical] : Plot difference Image between x_original and x_final

            (*) spicy [logical]: Subpackage of easter eggs 
    %}
    %% Welcome Message
    if i.spicy
        salsa.spicy.disp_salsa_bottle();
    end

    %% Initialize Stewchastic Solver
    if strcmp(algorithm, 'stewchastic')
        algorithm = salsa.spicy.stewchastic();
    end
    
    %% Initialize Empty Input Struct Fields with DEFAULTs
    i = salsa.util.default_input_param_completion(i, problem, algorithm);
    i.kernel = kernel;
    i.problem = problem;

    %% Initialize Starting Point Struct Fields with DEFAULTs
    x = salsa.util.default_starting_point_completion(x, algorithm, b);

    %% Set Prox Functions
    prox_f = @(x)         salsa.prox_lib.prox_f(x);
    prox_g = @(x, lambda) salsa.prox_lib.prox_g(problem, b, i, x, lambda);
    
    %% Print Algorithm Parameters
    if i.verbos
        fprintf('======================================================\n')
        fprintf('Running %s with %s-norm using:\n', algorithm, problem);
        fprintf('gamma = %G, ', eval(strcat('i.gamma',problem)));
    end

    %% Call Algorithms
    param = "(prox_f, prox_g, x, b, i)";
    alg = "salsa.algorithms." + algorithm;
    solver_call = eval("@" + param + alg + param);
    [x_final, rel_err] = solver_call(prox_f, prox_g, x, b, i);

    %% Plot Final Resault
    if i.plt_final
        fig_name = "Final Deblurred and Denoised Image";
        title_msg = "Using " + algorithm + " Solver and " + problem + "-norm";
        salsa.img.display(x_final, fig_name, title_msg);
    end

    %% Plot Relative Error vs #Iterations
    if i.plt_rel_err
        salsa.util.plt_rel_err(rel_err, i.sample_rate)
    end

    %% Plot Difference Image
    if i.plt_diff && isfield(x, 'I')
        I_diff = imabsdiff(x.I, x_final);
        fig_name = "Difference Image of Deblurred and Denoised Image";
        title_msg = "Difference Image Using " + algorithm + " Solver and " + problem + "-norm";
        salsa.img.display(I_diff, fig_name, title_msg);
    end
end