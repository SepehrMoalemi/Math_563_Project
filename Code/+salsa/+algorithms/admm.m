%% Purpose: Alternating Direction Method of Multipliers (ADMM)
function x = admm(prox_g, x, b, i)
    [f_A, f_A_T, f_I_ATA, f_inv_I_ATA] = salsa.fft.get_transformations(kernel, b);
    
end