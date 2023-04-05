%% Purpose: Plot Relative Error vs Iteration #
function plt_rel_err(rel_err,sample_rate)
    arguments 
        rel_err (:,1) double
        sample_rate double
    end
    fig = figure('Name','Relative Error');
    ax  = axes(fig);
    dim = length(rel_err);
    k = (1:dim)*sample_rate;
    plot(ax,k, rel_err, 'r--')
    title(ax,'||x^k - x^*||/||x^*||')
    
    xlabel(ax,'Iteration Number'); ylabel(ax,'Relative Error')
    box(ax,'on');grid(ax,'on');
    set(ax,'Yscale','log', 'FontSize',14)
end