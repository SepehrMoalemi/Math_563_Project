%% Purpose: Interface for the SALSA package
function x = solver(problem, algorithm, x, kernel, b, i)
    arguments
        problem   (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        algorithm (1,:) char {mustBeMember(algorithm, ...
                                            {'douglasrachfordprimal', ...
                                             'douglasrachfordprimaldual', ...
                                             'admm', ...
                                             'chambollepock'})}

        x      struct
        kernel double
        b      double
        i      struct = salsa.defaults.get_input_param_def()
    end
    %{ 
        x_final = salsa('problem', 'algorithm', x_initial, kernel, b, i)
    
        %% problem [char]: Choice of Norm in the Optimization Function
            OPTIONS: ['l1' | 'l2']
        
        %% algorithm [char]: Optimization Algorithm  
            OPTIONS: ['douglasrachfordprimal'     |
                      'douglasrachfordprimaldual' |
                      'admm'                      |
                      'chambollepock']
    
        %% x_initial[(:,:) double]: Initial Iterate
    
        %% kernel[(:,:) double]: Convolution Kernel (refer to fspecial)
    
        %% b[(:,:) double]: Bluered and Noisy Image
    
        %% i[struct]: Input Parameter
            OPTIONS: 
            (*) maxiter [int]: Iteration Limit
            (*) gammal1 [double]: Amount of De-noising in l1
            (*) gammal2 [double]: Amount of De-noising in l2
            (*) rhoprimaldr [double]: Relaxation Parameter rho in douglasrachfordprimal
            (*) tprimaldr   [double]: Stepsize t   in douglasrachfordprimal
            (*) rhoprimaldualdr [double]: Relaxation Parameter rho in douglasrachfordprimaldual
            (*) tprimaldualdr   [double]: Stepsize t   in douglasrachfordprimaldual
            (*) rhoadmm [double]: Relaxation Parameter pho in ADMM
            (*) tadmm   [double]: Stepsize t in ADMM
            (*) tcp [double]: stepsize for chambollepock
            (*) scp [double]: stepsize for chambollepock
            (*) sample_rate [int]: Output to screen frequency
            (*) verbos [logical]: Print to terminal or not
    %}
    
    %% Initialize Empty Input Struct Fields
    i = salsa.util.default_input_param_completion(i);
    i.kernel = kernel;

    %% Set Prox Functions
    prox_f = @(x)         salsa.prox_lib.prox_f(x);
    prox_g = @(x, lambda) salsa.prox_lib.prox_g(problem, b, i, x, lambda);
    
    %% Set objective function
    objective = @(x, f_A) salsa.objective.objective(x, b, problem, i, f_A);

    %% Print Algorithm Parameters
    if i.verbos
        fprintf('\n==================================\n')
        fprintf('Running %s with %s-norm using:\n', algorithm, problem);
        fprintf('gamma = %G\n', eval(strcat('i.gamma',problem)));
    end

    %% Call Algorithms
    param = "(objective, prox_f, prox_g, x, b, i)";
    alg = "salsa.algorithms." + algorithm;
    algorithm = eval("@" + param + alg + param);
    [x, rel_err] = algorithm(objective, prox_f, prox_g, x, b, i);

    %% Plot Convergence
    if i.ind_plot
        salsa.util.plt_rel_err(rel_err, i.sample_rate)
    end
    if i.comb_plot
        salsa.util.plt_rel_err_comb(i.fig, rel_err, i.sample_rate)
    end
end