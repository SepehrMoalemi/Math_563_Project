function print_completion(rel_err, f_obj_final, time)
    fprintf('\n====================================================\n');
    if rel_err(end) >= rel_err(1) || isinf(f_obj_final)
        fprintf(2,'**** Algorithm did Not Converge in given maxiter ***\n')
    end
    fprintf('Total Elapsed Time: %fs\n', time);
    fprintf('Final Objective Value = %0.2E',f_obj_final);
    fprintf('\n====================================================\n');
end