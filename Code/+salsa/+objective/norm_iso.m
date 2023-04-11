%% Iso Norm
function result = norm_iso(y2)
    [m, n, k] = size(y2);
    result = 0;
    
    % For Tensor
    %{
        let x be in R^(m*n*2) st:
            x = (x1,x2) for x1,x2 in R^(m*n) 
        Then:
        ||(x1,x2)||_iso = sum(x1_ij, x2_ij) for i=1:m, j=1:n
    %}

    for i=1:m
        for j=1:n
            result = result + sqrt(y2(i,j,1)^2 + y2(i,j,2)^2);
        end
    end

end