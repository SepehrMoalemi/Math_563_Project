%% Purpose: Print parameters in use for the algorithm
function print_param(arg1, arg2, x)
    if isfield(x, 'I')
        type = 'I';
    else
        type = 'xk_1';
    end
    fprintf('%s = %G, %s = %G\n', inputname(1), arg1, inputname(2), arg2);
    fprintf('\nUsing Rel_Error_Value      = ||xk - %s||/||%s||\n', type, type);
    fprintf('Using Rel_Error_Optimality = |f(xk) - f(%s)|/|f(%s)|\n', type, type);
    fprintf('======================================================\n');
end