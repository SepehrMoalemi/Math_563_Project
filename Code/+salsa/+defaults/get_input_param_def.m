function i_def = get_input_param_def()
    %{
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
    %% Default Values
    i_def.maxiter = nan;

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
end