%% returns objective function lambda
function result = objective(x, b, problem, i, f_A)
    arguments
        x
        b           double
        problem     (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        i           struct
        f_A 
    end
    %% Set objective function
    switch problem
        case 'l1'
            norm_fct = @(y1) norm(x-b, 1);
            gamma = i.gammal1;
        case 'l2'
            norm_fct = @(y1) norm(x-b, 2)^2;
            gamma = i.gammal2;
    end
    
    y = f_A(x);
    y1 = y(:,:,1);
    y2 = y(:,:,2:3);
    
    result = norm_fct(y1) + salsa.objective.indicator_box(x) + gamma*salsa.objective.norm_iso(y2);
end