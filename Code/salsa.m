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
    x = 0;
end