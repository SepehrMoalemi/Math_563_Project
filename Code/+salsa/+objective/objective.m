%% returns objective function lambda
function result = objective(x, b, f_A, i)
    arguments
        x    double
        b    double
        f_A  function_handle
        i    struct
    end
    %%  Assign norm functions based on problem type
    %{
             g      =    g1(y1)        + gamma*g2(y2)       
        g([y1 y2]') =  ||y1 - b||_1    + gamma*||y2||_iso (1)
        g([y1 y2]') = (||y1 - b||_2)^2 + gamma*||y2||_iso (2)
    %}
    switch i.problem
        case 'l1'
            norm_fct = @(y1) norm(x-b, 1);
            gamma = i.gammal1;
        case 'l2'
            norm_fct = @(y1) norm(x-b, 2)^2;
            gamma = i.gammal2;
    end
    
    %% Get [Kx, Dx]'
    y  = f_A(x);
    y1 = y(:,:,1);
    y2 = y(:,:,2:3);
    
    result = norm_fct(y1) + ...
             salsa.objective.indicator_box(x) + ...
             gamma*salsa.objective.norm_iso(y2);
end