%% Indicator fucntion for 0 < x < 1
function result = indicator_box(x)
    [m, n] = size(x);
    result = 0;

    x_up = x >= 1;
    x_down = x <= 0;
    x_outside = x_up | x_down;
    
    if any(x_outside)
        result = Inf;
    else
        result = 0;
    end
end