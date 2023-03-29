%% Purpose: Prox of indicator function l<=x<=u
function x = boxProx(x, l, u)
    arguments
        x
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end

    %% Set Out of Box Indices to Border Values
    % lower = x < l; x(lower) = l;
    % upper = x > u; x(upper) = u;
    prox = @(X) max(min(X, u), l);

    %% Apply prox to vec/matrix x
    x = salsa.aux.apply_prox(prox, x);
end

