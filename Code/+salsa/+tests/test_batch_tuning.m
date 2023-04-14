%% Purpose: Batch test tuning parameters
function test_batch_tuning(file_path, algorithms, ...
                           problems, gammal1s, gammal2s, ...
                           arg1s, arg2s, ...
                           maxIters, sample_rate, ...
                           blur_type, blur_arg, ...
                           noise_type, noise_arg, ...
                           pad_type)
    arguments
        file_path char {mustBeFile(file_path)}
        algorithms string {mustBeMember(algorithms, ...
                                        ["douglasrachfordprimal", ...
                                         "douglasrachfordprimaldual", ...
                                         "admm", ...
                                         "chambollepock"])}
        problems
        gammal1s
        gammal2s
        arg1s
        arg2s
        maxIters    = 500
        sample_rate = 10
        blur_type = 'motion'
        blur_arg  = {}
        noise_type = 'salt & pepper'
        noise_arg  = {}
        pad_type = 'circular'
    end

    %% Load Image
    show_raw = false;
    I = salsa.img.load(file_path, show_raw);

    %% Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = true;
    I = salsa.img.pre_process(I, to_grayscale, resize, show_preproc);

    x_init.x_original = I;            % Store x_original for Relative Error Calculations

    %% Blur Image
    [kernel, b] = salsa.img.add_blur(I, blur_type, blur_arg, pad_type);

    %% Add Noise
    b = salsa.img.add_noise(b, noise_type, noise_arg);
    [m, n] = size(b);
    
    %% Set Printing Rate
    i.sample_rate = sample_rate;

    %% Figure Merger
    % Choose arg2 legend name based on alg
    arg2_name = "rho";
    if algorithms(1) == "chambollepock"
        arg2_name = "s";
    end

    % Abbreviation of algorithms for legend
    algorithm_names = [];
    for algorithm = algorithms
        switch algorithm
            case "douglasrachfordprimal"
                algorithm_names = [algorithm_names, "primal DR"];

            case "douglasrachfordprimaldual"
                algorithm_names = [algorithm_names, "primal-dual DR"];

            case "admm"
                algorithm_names = [algorithm_names, "ADMM"];

            case "chambollepock"
                algorithm_names = [algorithm_names, "CP"];
        end
    end

    params      = {algorithm_names, problems,     gammal1s, gammal2s, arg1s, arg2s};
    param_names = {algorithm_names, ["l1", "l2"], "\gamma", "\gamma", "t,",  arg2_name};
    param_len = length(params);

    % Make Legend
    mode = -1;
    legends = "";
    for cell=1:param_len
        grid_len = length(params{cell});
        if grid_len > 1
            mode = mode + 1;
            if mode == 1
                break
            end
            if cell == 1 || cell == 2
                legends = param_names{cell};
            else
                legends = param_names{cell} + " = " + string(params{cell});
            end
        end
    end

    % Setup Storing figures
    fig_num = 0;
    if legends ~= ""
        fig_collection = gobjects([2,length(legends)]);
    else
        fig_collection = gobjects([2,1]);
    end

    %% Iterate Over Grid
    for algorithm = algorithms
        for problem = problems
                switch problem
                    case 'l1'
                        gammas = gammal1s;
    
                    case 'l2'
                        gammas = gammal2s;
                end
            for gamma = gammas
                % Set Problem Smoothing Params
                i.gammal1 = gamma;
                i.gammal2 = gamma;
    
                % Set Optimization Algorithm Param
                for maxiter = maxIters
                    i.maxiter = maxiter;
                    for arg1 = arg1s
                        for arg2 = arg2s
                            %% Set Initial Conditions
                            switch algorithm
                                case "douglasrachfordprimal"
                                    i.tprimaldr   = arg1;
                                    i.rhoprimaldr = arg2;
                                    arg1_name = "tprimaldr";
                                    arg2_name = "rhoprimaldr";
                                    x_init.z1 = b;
                                    x_init.z2 = zeros(m,n,3);
    
    
                                case "douglasrachfordprimaldual"
                                    i.tprimaldualdr   = arg1;
                                    i.rhoprimaldualdr = arg2;
                                    arg1_name = "tprimaldualdr";
                                    arg2_name = "rhoprimaldualdr";
                                    x_init.p0 = b;
                                    x_init.q0 = zeros(m,n,3);
    
                                case "admm"
                                    i.tadmm   = arg1;
                                    i.rhoadmm = arg2;
                                    arg1_name = "tadmm";
                                    arg2_name = "rhoadmm";
                                    x_init.x0 = b;
                                    x_init.y0 = zeros(m,n,3);
                                    x_init.z0 = zeros(m,n,3);
                                    x_init.u0 = b;
                                    x_init.w0 = b;
    
                                case "chambollepock"
                                    i.tcp = arg1;
                                    i.scp = arg2;
                                    arg1_name = "tcp";
                                    arg2_name = "scp";
                                    x_init.x0 = b;
                                    x_init.y0 = zeros(m,n,3);
                                    x_init.z0 = b;
                            end
    
                            plt_name =  problem + ...
                                        "_maxiter_" + num2str(maxiter)+ ...
                                        "_gamma_" + num2str(gamma)+ ...
                                        arg1_name + num2str(arg1)+ ...
                                        arg2_name + num2str(arg2)+"_";
    
                            % Run Algorithm
                            x_out = salsa.solver(problem, algorithm, x_init, kernel, b, i);
                            
                            dir_res_chamb = "./Results/" + algorithm + "/";
                            salsa.util.mkdir_if_no_dir(dir_res_chamb)

                            % Store Figures
                            figs = findobj('Type', 'figure');
                            fig_num = fig_num + 1;
                            fig_collection(:,fig_num) = figs(1:2);
    
                            % Plot Deblurred Image
                            fig = figure('Name',"Deblurred Image #" + num2str(fig_num) );
                            imshow(x_out,[])
                            saveas(fig,dir_res_chamb+plt_name+".png")
                            
                            if mode == 1
                                close all;
                            end
                        end
                    end
                end
            end
        end
    end

    %% Plot Merged Figures
    fig_rel_err = fig_collection(2,:);
    fig_rel_obj = fig_collection(1,:);
    
    handleLine = findobj(fig_rel_err,'type','line');
    merged_fig = figure('Name',"Relative Error");
    ax = axes(merged_fig);
    hold on;
    for indx = 1:length(handleLine)
        line = handleLine(indx);
        plot(get(line,'XData'), get(line,'YData'), '--') ;
    end
    title(ax,'||x^k - x^*||/||x^*||')
    xlabel('Iteration Number'); ylabel('Relative Error')
    box('on');grid('on');
    if legends ~= ""
        legend(legends);
    end
    set(ax, 'Yscale','log', 'FontSize',14)

    handleLine = findobj(fig_rel_obj,'type','line');
    merged_fig = figure('Name',"Optimality gap");
    ax = axes(merged_fig);
    hold on;
    for indx = 1:length(handleLine)
        line = handleLine(indx);
        plot(get(line,'XData'), get(line,'YData'), '--') ;
    end
    title(ax,'(f(x^k) - f(x^*))/f(x^*)')
    xlabel(ax,'Iteration Number'); ylabel(ax,'Relative Objective Value')
    box('on');grid('on');
    if legends ~= ""
        legend(legends);
    end
    set(ax, 'Yscale','log', 'FontSize',14)
end