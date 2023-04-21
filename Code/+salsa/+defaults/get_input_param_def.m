function i_def = get_input_param_def(problem, algorithm)
    arguments
        problem   (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        algorithm string {mustBeMember(algorithm, ...
                                ["douglasrachfordprimal", ...
                                 "douglasrachfordprimaldual", ...
                                 "admm", ...
                                 "chambollepock"])}
    end
    %{
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
    %% Default Values for solver
    i_def.maxiter = 500;

    %% Defaut Problem Values
    switch problem
        case 'l1'
            i_def.gammal1 = 0.025; 
            rhoprimaldr = 1.5;
            tprimaldr   = 0.05;
            rhoprimaldualdr = 0.5;
            tprimaldualdr   = 4;
            rhoadmm = 1.0;
            tadmm   = 1.5;
            scp = 0.4;
            tcp = 0.4;
        case 'l2'
            i_def.gammal2 = 0.035;
            rhoprimaldr = 1.5;
            tprimaldr   = 0.09;
            rhoprimaldualdr = 1.3;
            tprimaldualdr   = 0.006;
            rhoadmm = 0.4;
            tadmm   = 1.0;
            scp = 0.2;
            tcp = 0.2;
    end     

    %% Default Algorithm Values
    switch algorithm
        case "douglasrachfordprimal"
            i_def.rhoprimaldr = rhoprimaldr;
            i_def.tprimaldr   = tprimaldr;

        case "douglasrachfordprimaldual"
            i_def.rhoprimaldualdr = rhoprimaldualdr; 
            i_def.tprimaldualdr   = tprimaldualdr; 

        case "admm"
            i_def.rhoadmm = rhoadmm;
            i_def.tadmm   = tadmm;

        case "chambollepock"           
            i_def.scp = scp;
            i_def.tcp = tcp;  
    end

    %% Default Printing + Plotting Values
    i_def.sample_rate = 10;
    i_def.verbos = true;

    i_def.plt_final    = true;
    i_def.plt_progress = false;
    i_def.plt_rel_err  = false;
    i_def.plt_diff     = false;

    %% Default Easter egg value
    i_def.spicy = false;
end