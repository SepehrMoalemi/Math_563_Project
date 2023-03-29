%% Purpose: Prox of Isotropic function
% ||x, y||iso = sum(sqrt(xi^2 + yi^2))
% Assumes x = [x1, x2] 
% x1 = x(:,:,1)
% x2 = x(:,:,2)
function x = isoProx(x, lambda)
    arguments
        x      (:,:,2) double
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Extract x = (x1,x2)
    x1 = x(:,:,1);
    x2 = x(:,:,2);
    
    %% Prox_lambda ||(x1,x2)||_iso
    %{
        prox_lambda ||(x1,x2)||_iso = (u, v)
    
        Let rk = sqrt(x1_k^2 + x2_k^2)

        (uk, vk) = alphak(x1_k, x2_k)

                 { 1 - lambda/rk if rk > lambda
        alphak = {
                 { 0              else
    %}
    [m, n] = size(x1);
    alpha = zeros(m,n);
    for i = 1:m
        for j = 1:n
            if sqrt(x1(i,j)^2 + x2(i,j)^2) > lambda
                alpha(i,j) = 1 - lambda/sqrt(x1(i,j)^2 + x2(i,j)^2);
            end
        end
    end

    %% x = (alpha, alpha)
    x = cat(3, alpha, alpha);
end