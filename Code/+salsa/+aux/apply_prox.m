%% Purpose: Apply Prox to x
% x can be a vector OR matrix
function x = apply_prox(prox,x)
    arguments
        prox function_handle
        x    double
    end

    %% Check if x is a Vector or Matrix
    dim = size(x,2);
    if dim == 1
        x = prox(x);
    else
        x = splitapply(prox, x, 1:dim);
    end
end

