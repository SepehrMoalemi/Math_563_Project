%% Purpose: Prox of indicator function l<=x<=u
function x = boxProx(x, l, u)
    arguments
        x (:,:) double
        l double                                 = 0
        u double {mustBeGreaterThanOrEqual(u,l)} = 1
    end
    %% Prox indicator_s(x)
    %{
        Let C = {x : l <= x <= u}
        Define :
                       { 0  for x in C
            Ind_C(x) = {
                       {inf for x not in C
        Then
                              { l    for  l >  xi
            Prox Ind_C(x)  =  { xi   for  l <= xi <= u
                              { u    for       xi >  u
    %}
    x = max(min(x, u), l);
end
