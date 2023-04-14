function print_param(arg1, arg2)
    fprintf('%s = %G, %s = %G\n', inputname(1), arg1, inputname(2), arg2);
    fprintf('Using Rel_Error_Value      = ||xk - xk_1||/||xk_1||\n');
    fprintf('Using Rel_Error_Optimality = |f(x^k) - f(x^*)|/|f(x^*)|\n');
        fprintf('====================================================\n');
end