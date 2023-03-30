%% Purpose: Prox of indicator function l<=x<=u
function x = boxProx(x, lambda, l, u)
    arguments
        x (:,:) double
        lambda double {mustBePositive(lambda)} = 1
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end

    %% Set Out of Box Indices to Border Values
    % lower = x < l; x(lower) = l;
    % upper = x > u; x(upper) = u;
    prox = @(X) (1/lambda) * max(min(X, u), l);

    %% Apply prox to vec/matrix x
    x = salsa.aux.apply_prox(prox, x);
end

