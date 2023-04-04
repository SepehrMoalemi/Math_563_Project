%% Purpose: Plot Relative Error vs Iteration #
function plt_rel_err(rel_err,sample_rate)
    fig = figure('Name','Relative Error');
    ax  = axes(fig);
    dim = length(rel_err);
    k = (1:dim)*sample_rate;
    plot(ax,k, rel_err, 'r--')
    title(ax,'||x^k - x^*||/||x^*||')
    ylabel(ax,'Relative Error')
    xlabel(ax,'Iteration Number')
    box(ax,'on');grid(ax,'on');
    set(ax,'Yscale','log')
    set(ax,'FontSize',14)
end

