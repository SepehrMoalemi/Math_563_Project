%% Purpose: Prox of indicator function l<=x<=u
function x = boxProx(x, l, u)
    arguments
        x
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end

    %% Get Out of Box Indices 
    lower = x < l;
    upper = x > u;

    %% Set Out of Box Indices to Border Values
    x(lower) = l;
    x(upper) = u;
end
