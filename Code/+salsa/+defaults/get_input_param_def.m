function i_def = get_input_param_def()
    %{
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
    %% Default Values
    i_def.maxiter = 100;

    i_def.gammal1 = nan;         
    i_def.gammal2 = nan;

    i_def.rhoprimaldr = nan;
    i_def.tprimaldr   = nan;

    i_def.rhoprimaldualdr = nan; 
    i_def.tprimaldualdr   = nan; 

    i_def.rhoadmm = nan;
    i_def.tadmm   = nan;

    i_def.tcp = nan;             
    i_def.scp = nan;

    i_def.sample_rate = 2;
    i_def.verbos = true;
    i_def.ind_plot = true;
end