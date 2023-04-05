%% Purpose: Testing default input parameter completion
function test_default_input_param_completion()
    i.maxiter = 69;
    i.tcp = 12;
    i = salsa.util.default_input_param_completion(i)
end

