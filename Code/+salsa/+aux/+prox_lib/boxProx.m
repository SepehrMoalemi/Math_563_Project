%% Purpose: Prox of indicator function l<=x<=u
function x = boxProx(x, l, u)
    arguments
        x (:,:) double
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end

    %% Set Out of Box Indices to Border Values
    % lower = x < l; x(lower) = l;
    % upper = x > u; x(upper) = u;
    x = max(min(x, u), l);
end

