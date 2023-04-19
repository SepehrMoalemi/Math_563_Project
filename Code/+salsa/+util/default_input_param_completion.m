%% Purpose: Sets Missing Input Parameters to Default
function i = default_input_param_completion(i, problem, algorithm)
    arguments
        i struct
        problem   (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        algorithm string {mustBeMember(algorithm, ...
                                ["douglasrachfordprimal", ...
                                 "douglasrachfordprimaldual", ...
                                 "admm", ...
                                 "chambollepock"])}
    end

    %% Get defualt values
    i_def = salsa.defaults.get_input_param_def(problem, algorithm);

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
                assert(isInteger(val) && isPositive(val), "i." + key + " must be a Postive Integer!");
            case {'verbos', 'plt_final', 'plt_progress', 'plt_rel_err', 'plt_diff', 'spicy'}
                assert(islogical(val), "i." + key + " must be True or False Logical Value!");
            otherwise
                txt = "i." + key + " must be a Postive Real Value!";
                assert(isPositive(val), txt);
        end
    end

    % Check if maxiter <  sample_rate
    if isfield(i, 'maxiter')
        if isfield(i, 'sample_rate')
            if i.maxiter < i.sample_rate
                warning("sample_rate should be smaller than maxiter. Proceesing with sample_rate = 1.");
                i.sample_rate = 1;
            end
        else
            if i.maxiter < i_def.sample_rate
                i_def.sample_rate = floor(i.maxiter/100) + 1;
            end
        end
    end
    if isfield(i, 'sample_rate')
        if i_def.maxiter < i.sample_rate
            warning("sample_rate should be smaller than maxiter. Proceesing with sample_rate = 1.");
            i.sample_rate = 1;
        end
    end

    % Get indices of missing fields
    empty_fields = find(~ismember(i_def_f, i_f));

    % Assign Defualt Values to missing fields
    for indx = 1:length(empty_fields)
        key = i_def_f{empty_fields(indx)};
        val = i_def.(key);
        i.(key) = val;
        fprintf("Using DEFAULT i.%s = %G\n", key, val)
    end
end

%% Helper Functions for Argument type Checks
function result = isInteger(val)
    result = isreal(val) && isnumeric(val) && isfinite(val) && eq(floor(val), val);
end

function result = isPositive(val)
    result = isreal(val) && isnumeric(val) && gt(val, 0);
end