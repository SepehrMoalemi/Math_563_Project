%% Purpose: Choose Error Calculation type
% Used raw image in the form of I, if available
% Otherwise use last iterarion values
function [obj_fun, f_val_err, f_opt_err] = rel_err_fun(x, b, f_A, i)
    %% Set objective function
    obj_fun = @(x) salsa.objective.objective(x, b, f_A, i);

    %% Relative Error Calculations
    if isfield(x, 'I')
        f_val_err = @(xk, xk_old) abs(norm(x.I - xk))/norm(x.I);
        opt_original = obj_fun(x.I);
        f_opt_err = @(xk, xk_old) abs(obj_fun(xk) - opt_original)/opt_original;
    else
        f_val_err = @(xk, xk_old) abs(norm(xk_old - xk))/norm(xk_old);
        f_opt_err = @(xk, xk_old) abs(obj_fun(xk) - obj_fun(xk_old))/obj_fun(xk_old);
    end
end