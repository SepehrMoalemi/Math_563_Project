%% Purpose: Initialize x based on algorithm
function x_init = get_starting_point_def(algorithm, b)
    arguments
        algorithm (1,:) char {mustBeMember(algorithm, ...
                                            {'douglasrachfordprimal', ...
                                             'douglasrachfordprimaldual', ...
                                             'admm', ...
                                             'chambollepock'})}
        b  double
    end

    %% Get dims
    [m, n] = size(b);

    %% Set Initial Conditions
    switch algorithm
        case "douglasrachfordprimal"
            x_init.z1 = b;
            x_init.z2 = zeros(m,n,3);


        case "douglasrachfordprimaldual"
            x_init.p0 = b;
            x_init.q0 = zeros(m,n,3);

        case "admm"
            x_init.x0 = b;
            x_init.y0 = zeros(m,n,3);
            x_init.z0 = zeros(m,n,3);
            x_init.u0 = b;
            x_init.w0 = b;

        case "chambollepock"
            x_init.x0 = b;
            x_init.y0 = zeros(m,n,3);
            x_init.z0 = b;
    end
end