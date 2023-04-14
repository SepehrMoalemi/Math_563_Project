function x = default_starting_point_completion(x, algorithm, b)
    arguments
        x struct
        algorithm (1,:) char {mustBeMember(algorithm, ...
                                    {'douglasrachfordprimal', ...
                                     'douglasrachfordprimaldual', ...
                                     'admm', ...
                                     'chambollepock'})}
        b  double
    end

    %% Get defualt values
    x_def = salsa.defaults.get_starting_point_def(algorithm, b);

    %% Set Missing Default Values
    x_f     = fieldnames(x);
    x_def_f = fieldnames(x_def);
    
    % Get indices of provided fields
    filled_fields = find(ismember(x_f, x_def_f));

    % Check Validity of fields
    [m, n] = size(b);
    for indx = 1:length(filled_fields)
        key = x_f{filled_fields(indx)};
        val = x.(key);
        switch key
            case {'x0', 'u0', 'w0', 'p0', 'z1'}
                x_size = size(zeros(m,n));
                msg = sprintf("x.%s must of be shape [%d, %d]!", key, m, n);
            case 'z0'
                if strcmp(algorithm, 'chambollepock')
                    x_size = size(zeros(m,n));
                    msg = sprintf("x.%s must of be shape [%d, %d]!", key, m, n);
                else
                    x_size = size(zeros(m,n,3));
                    msg = sprintf("x.%s must of be shape [%d, %d, %d]!", key, m, n, 3);
                end
            otherwise
                x_size = size(zeros(m,n,3));
                msg = sprintf("x.%s must of be shape [%d, %d, %d]!", key, m, n, 3);
        end
        try 
            eq(size(val), x_size);
        catch
            error(msg);
        end
    end

    % Get indices of missing fields
    empty_fields = find(~ismember(x_def_f, x_f));

    % Assign Defualt Values to missing fields
    for indx = 1:length(empty_fields)
        key = x_def_f{empty_fields(indx)};
        val = x_def.(key);
        x.(key) = val;
    end
end