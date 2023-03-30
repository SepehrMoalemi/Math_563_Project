%% Purpose: Prox of Isotropic function
% ||w1, w2||iso = sum(sqrt(w1_i^2 + w2_i^2))
% Assumes y2 = [w1, w2] 
% w1 = y2(:,:,1)
% w2 = y2(:,:,2)
function x = isoProx(y2, lambda)
    arguments
        y2      (:,:,2) double
        lambda double {mustBePositive(lambda)} = 1
    end
    %% Extract x = (w1,w2)
    w1 = y2(:,:,1);
    w2 = y2(:,:,2);
    
    %% Prox_lambda ||(w1,w2)||_iso
    %{
        prox_lambda ||(w1,w2)||_iso = (u, v)
    
        Let rk = sqrt(w1_k^2 + w2_k^2)

        (uk, vk) = alphak(w1_k, w2_k)

                 { 1 - lambda/rk if rk > lambda
        alphak = {
                 { 0              else
    %}
    [m, n] = size(w1);
    alpha = zeros(m,n);
    for i = 1:m
        for j = 1:n
            if sqrt(w1(i,j)^2 + w2(i,j)^2) > lambda
                alpha(i,j) = 1 - lambda/sqrt(w1(i,j)^2 + w2(i,j)^2);
            end
        end
    end

    %% x = (alpha, alpha)
    x = cat(3, alpha, alpha);
end