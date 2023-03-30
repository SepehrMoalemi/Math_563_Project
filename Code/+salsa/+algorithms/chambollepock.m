%% Purpose: Chambolle-Pock Method
function x = chambollepock(prox_g, x, b, i)
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

    [f_A, f_A_T, f_I_ATA, f_inv_I_ATA] = salsa.fft.get_transformations(kernel, b)

end

