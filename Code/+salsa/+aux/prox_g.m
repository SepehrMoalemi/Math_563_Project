%% Purpose: Prox of g
% Type l1 | l2
% Given x and lambda
% Calculates prox_lambda g, with 
% l1-norm | l2-norm-squared as first term
% the separation of  y can be explained as is done below
% y = Ax = [K; D]x = [ Kx; Dx ] = [ y1; [w1; w2] ]
function y = prox_g(problem, b , i, y, lambda)
    arguments
        problem (1,:) char {mustBeMember(problem, ...
                                            {'l1', ...
                                             'l2'})}
        b (:,:) double
        i struct
        y (:,:,3) double
        lambda double {mustBePositive(lambda)} = 1
    end
    
    %% Split y
    y1 = y(:,:,1);
    y2 = y(:,:,2:3);

    %% Choose Problem type
    %{
             g       =   g1(y1)        +    gamma*g2(y2)       
        g([y1 y2]') =  ||y1 - b||_1    + gamma*||y2||_iso (1)
        g([y1 y2]') = (||y1 - b||_2)^2 + gamma*||y2||_iso (2)
    %}
    switch problem
        case 'l1'
            prox_g1  = @(y1, lambda) salsa.aux.prox_lib.l1Prox(y1 - b, lambda);
            gamma = i.gammal1;
        case 'l2'
            prox_g1  = @(y1, lambda) salsa.aux.prox_lib.l2_sq_Prox(y1 - b, lambda);
            gamma = i.gammal2;
    end

    %% Find prox
    %{
                                    [Prox_lambda       g1(y1)]
        Prox_lambda g([y1 y2]') =   [                        ]
                                    [Prox_lambda gamma*g2(y2)]
        And,
        
        Porx_lamda gamma*g2(y2) = Porx_alpha g2(y2)
        
        Where alpha = lamda*gamma
        
    %}
    y = cat(3,prox_g1(y1, lambda), ...
              salsa.aux.prox_lib.isoProx(y2, lambda*gamma));
end

