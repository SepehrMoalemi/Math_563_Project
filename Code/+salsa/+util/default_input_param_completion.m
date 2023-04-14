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
    
    % Get indices of provided fields
    filled_fields = find(ismember(i_f, i_def_f));

    % Check Validity of fields
    for indx = 1:length(filled_fields)
        key = i_f{filled_fields(indx)};
        val = i.(key);
        switch key
            case {'maxiter', 'sample_rate'}
                assert(isInteger(val) && isPositive(val), "i.maxiter must be a Postive Integer!");
            case 'verbos'
                assert(islogical(val), "i.verbos must be True or False Logical Value!");
            otherwise
                txt = "i." + num2str(key) + " must be a Postive Integer!";
                assert(isPositive(val), txt);
        end
    end

    % Get indices of missing fields
    empty_fields = find(~ismember(i_def_f, i_f));

    % Assign Defualt Values to missing fields
    for indx = 1:length(empty_fields)
        key = i_def_f{empty_fields(indx)};
        val = i_def.(key);
        i.(key) = val;
    end
end

function result = isInteger(val)
    result = isreal(val) && isnumeric(val) && isfinite(val) && eq(floor(val), val);
end

function result = isPositive(val)
    result = isreal(val) && isnumeric(val) && gt(val, 0);
end