%% Purpose: Plot Relative Error vs Iteration #
function plt_rel_err_comb(fig, rel_err,sample_rate)
    arguments 
        fig
        rel_err struct
        sample_rate
    end
    set(0, "CurrentFigure", fig)

    dim = length(rel_err.opt);
    k = (1:dim)*sample_rate;
    semilogy(k, rel_err.opt, '--')
    title('(f(x^k) - f(x^*))/f(x^*)')

    xlabel('Iteration Number'); ylabel('Relative Objective Value')
    box('on');grid('on');
end