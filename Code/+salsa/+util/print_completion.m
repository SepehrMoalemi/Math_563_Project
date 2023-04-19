%% Purpose: Print Time Elapsed + Final Objective Value
function print_completion(rel_err, f_obj_final, time, spicy)
    fprintf('======================================================\n');
    if rel_err(end) >= rel_err(1) || isinf(f_obj_final)
        fprintf(2,'**** Algorithm did Not Converge in given maxiter ***\n')
        if spicy
            salsa.spicy.disp_salsa_error()
        end
    end
    fprintf('Total Elapsed Time: %fs\n', time);
    fprintf('Final Objective Value = %0.2E',f_obj_final);
    fprintf('\n======================================================\n');
end