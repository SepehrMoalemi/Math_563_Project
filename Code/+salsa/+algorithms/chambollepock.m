%% Purpose: Chambolle-Pock Method
function x = chambollepock(x, b, t, s)
%{
    solves the generic convex optimization problem:
            min f(x) + g(y)
            x,y
        subject to Ax = y
    by finding the solutions (x^hat, y^hat) of the 
    saddle point problem:
            min max <Ax,y> + f(x) - g^*(y)
             x   y
    Where A = [K D]'
    convergence is garunteed for s*t*(||A||^2) < 1
%}

end

