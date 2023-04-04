%% Purpose: Interface for the SALSA package
function x = salsa(problem, algorithm, x, kernel, b, i)
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
    
        %% x_initial[?]: Initial Iterate
    
        %% kernel[?]: Convolution Kernel (refer to fspecial)
    
        %% b[?]: Bluered and Noisy Image
    
        %% i[struct]: Input Parameter
            OPTIONS: 
            (*) maxiter [int]: Iteration Limit
            (*) gammal1 [?]: Amount of De-noising in l1
            (*) gammal2 [?]: Amount of De-noising in l2
            (*) rhoprimaldr [?]: Relaxation Parameter rho in douglasrachfordprimal
            (*) tprimaldr   [?]: Stepsize t   in douglasrachfordprimal
            (*) rhoprimaldualdr [?]: Relaxation Parameter rho in douglasrachfordprimaldual
            (*) tprimaldualdr   [?]: Stepsize t   in douglasrachfordprimaldual
            (*) rhoadmm [?]: Relaxation Parameter pho in ADMM
            (*) tadmm   [?]: Stepsize t in ADMM
            (*) tcp [?]: stepsize for chambollepock
            (*) scp [?]: stepsize for chambollepock
    %}
    
    %% Initialize Empty Input Struct Fields
    i = salsa.aux.default_input_param_completion(i);
    i.kernel = kernel;
    i.sample_rate = 100;

    %% Set Norm based on Problem
    prox_f = @(x) salsa.aux.prox_f(x);
    prox_g = @(x, lambda) salsa.aux.prox_g(problem, b, i, x, lambda);

    %% Print Algorithm Parameters
    fprintf('\n==================================\n')
    fprintf('Running %s with %s-norm using:\n', algorithm, problem);
    fprintf('gamma = %G\n', eval(strcat('i.gamma',problem)));

    %% Call Algorithms
    param = "(prox_f, prox_g, x, b, i)";
    alg = "salsa.algorithms." + algorithm;
    solver = eval("@" + param + alg + param);
    [x, rel_err] = solver(prox_f, prox_g, x, b, i);

    %% Plot Error
    salsa.aux.plt_rel_err(rel_err, i.sample_rate)
end