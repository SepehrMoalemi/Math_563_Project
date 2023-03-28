%% Purpose: Sets Missing Input Parameters to Default
function i = default_input_param_completion(i)
    arguments
        i struct
    end

    %% Get defualt values
    i_def = salsa.defaults.get_input_param_def();

    %% Set Missing Default Values
    i_f     = fieldnames(i);
    i_def_f = fieldnames(i_def);
    
    % Get indices of missing fields
    empty_fields = find(~ismember(i_def_f, i_f));

    % Assign Defualt Values to missing fields
    for indx = 1:length(empty_fields)
        key = i_def_f{empty_fields(indx)};
        val = i_def.(key);
        fprintf("Using DEFAULT i.%s = %G\n", key, val)
        i.(key) = val;
    end
end