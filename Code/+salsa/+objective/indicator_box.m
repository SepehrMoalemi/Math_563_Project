%% Indicator fucntion for u <= x <= l
function result = indicator_box(x, l, u)
    arguments
        x (:,:) double
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end
    %{
        Let C = {x : l <= x <= u}
        Define :
                       { 0  for x in C
            Ind_C(x) = {
                       {inf for x not in C
    %}
    x_up   = x >= u;
    x_down = x <= l;
    x_outside = x_up | x_down;
    
    if any(x_outside)
        result = Inf;
    else
        result = 0;
    end
end