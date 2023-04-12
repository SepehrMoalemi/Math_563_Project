%% Purpose: Plot Relative Error vs Iteration #
function plt_rel_err(rel_err,sample_rate)
    arguments 
        rel_err struct
        sample_rate double
    end
    % fig = figure('Name','Relative Error');
    % ax  = axes(fig);
    % dim = length(rel_err.val);
    % k = (1:dim)*sample_rate;
    % plot(ax,k, rel_err.val, 'r--')
    % title(ax,'||x^k - x^*||/||x^*||')
    % 
    % xlabel(ax,'Iteration Number'); ylabel(ax,'Relative Error')
    % box(ax,'on');grid(ax,'on');
    % set(ax,'Yscale','log', 'FontSize',14)
    
    % fig = figure('Name','Optimality gap');
    % ax  = axes(fig);
    % dim = length(rel_err.opt);
    % k = (1:dim)*sample_rate;
    % plot(ax,k, rel_err.opt, 'r--')
    % title(ax,'(f(x^k) - f(x^*))/f(x^*)')
    % 
    % xlabel(ax,'Iteration Number'); ylabel(ax,'Relative Objective Value')
    % box(ax,'on');grid(ax,'on');
    % set(ax,'Yscale','log', 'FontSize',14)
    
    if rel_err.flag == 69
        figure(69);
        % ax  = axes(fig);
        dim = length(rel_err.opt);
        k = (1:dim)*sample_rate;
        % plot(k, rel_err.opt, 'r--')
        semilogy(k, rel_err.opt, '--')
        title('(f(x^k) - f(x^*))/f(x^*)')
        
        xlabel('Iteration Number'); ylabel('Relative Objective Value')
        box('on');grid('on');
        % ax = axes(figure(69));
        % set(ax, 'Yscale','log', 'FontSize',14)
    
        hold on
    end

    if rel_err.flag == 70
        figure(70);
        % ax  = axes(fig);
        dim = length(rel_err.opt);
        k = (1:dim)*sample_rate;
        % plot(k, rel_err.opt, 'r--')
        semilogy(k, rel_err.opt, '--')
        title('(f(x^k) - f(x^*))/f(x^*)')
        
        xlabel('Iteration Number'); ylabel('Relative Objective Value')
        box('on');grid('on');
        % ax = axes(figure(69));
        % set(ax, 'Yscale','log', 'FontSize',14)
    
        hold on
    end
end