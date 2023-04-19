%% Purpose: Batch test tuning parameters
function test_batch_tuning(img_path, algorithms, ...
                           problems, gammal1s, gammal2s, ...
                           arg1s, arg2s, ...
                           maxiters, sample_rate, ...
                           blur_type, blur_arg, ...
                           noise_type, noise_arg, ...
                           pad_type)
    arguments
        img_path char {mustBeFile(img_path)}
        algorithms string {mustBeMember(algorithms, ...
                                        ["douglasrachfordprimal", ...
                                         "douglasrachfordprimaldual", ...
                                         "admm", ...
                                         "chambollepock"])}
        problems string {mustBeMember(problems, ...
                                      ["l1", ...
                                       "l2"])}
        gammal1s double {mustBeNonnegative(gammal1s)}
        gammal2s double {mustBeNonnegative(gammal2s)}
        arg1s double {mustBePositive(arg1s)}
        arg2s double {mustBePositive(arg2s)}
        maxiters    double {mustBeInteger,mustBePositive(maxiters)}    = 500
        sample_rate double {mustBeInteger,mustBePositive(sample_rate)} = 10
        blur_type  string {mustBeMember(blur_type, ...
                                        {'average',  ...
                                         'disk',     ...
                                         'gaussian'  ...
                                         'log'       ...
                                         'laplacian' ...
                                         'motion' ...
                                         'none'})} = 'motion'
        blur_arg  = {}
        noise_type string {mustBeMember(noise_type, ...
                                        {'gaussian',     ...
                                         'poisson',      ...
                                         'salt & pepper', ...
                                         'speckle', ...
                                         'none'})} = 'salt & pepper'
        noise_arg  = {}
        pad_type string {mustBeMember(pad_type, ...
                                      {'symmetric', ...
                                       'replicate', ...
                                       'circular'})} = 'circular'
    end
    %% Set i optional params
    i.plt_final    = false;
    i.plt_progress = true;
    i.plt_rel_err  = true;
    i.spicy = false;

    %% Load Image
    show_raw = false;
    I = salsa.img.load(img_path, show_raw);

    %% Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = true;
    I = salsa.img.pre_process(I, to_grayscale, resize, show_preproc);

    x_init.I = I;            % Store x.I for Relative Error Calculations

    %% Blur Image
    [kernel, b] = salsa.img.add_blur(I, blur_type, blur_arg, pad_type);

    %% Add Noise
    b = salsa.img.add_noise(b, noise_type, noise_arg);
    
    %% Set Printing Rate
    i.sample_rate = sample_rate;

    %% Figure Merger
    % Choose arg2 legend name based on alg
    arg2_name = "\rho";
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
    fig_collection = gobjects([2,length(legends)]);

    %% Iterate Over Grid
    problems_grid = problems;
    gammal1s_grid = gammal1s;
    gammal2s_grid = gammal2s;
    maxiters_grid = maxiters;
    arg1s_grid = arg1s;
    arg2s_grid = arg2s;
    
    alg_grid_len = length(algorithms);
    for alg_indx = 1:alg_grid_len
        % Set Algorithm
        algorithm = algorithms(alg_indx);
        if alg_grid_len > 1
            problems_grid = problems(alg_indx);
            gammal1s_grid = gammal1s(alg_indx);
            gammal2s_grid = gammal2s(alg_indx);
            maxiters_grid = maxiters(alg_indx);
            arg1s_grid = arg1s(alg_indx);
            arg2s_grid = arg2s(alg_indx);
        end

        for problem = problems_grid
                switch problem
                    case 'l1'
                        gammas = gammal1s_grid;
    
                    case 'l2'
                        gammas = gammal2s_grid;
                end
            for gamma = gammas
                % Set Problem Smoothing Params
                i.gammal1 = gamma;
                i.gammal2 = gamma;
    
                % Set Optimization Algorithm Param
                for maxiter = maxiters
                    i.maxiter = maxiters_grid;
                    for arg1 = arg1s_grid
                        for arg2 = arg2s_grid
                            %% Set Initial Conditions
                            switch algorithm
                                case "douglasrachfordprimal"
                                    i.tprimaldr   = arg1;
                                    i.rhoprimaldr = arg2;
                                    arg1_name = "tprimaldr";
                                    arg2_name = "rhoprimaldr";
    
                                case "douglasrachfordprimaldual"
                                    i.tprimaldualdr   = arg1;
                                    i.rhoprimaldualdr = arg2;
                                    arg1_name = "tprimaldualdr";
                                    arg2_name = "rhoprimaldualdr";
    
                                case "admm"
                                    i.tadmm   = arg1;
                                    i.rhoadmm = arg2;
                                    arg1_name = "tadmm";
                                    arg2_name = "rhoadmm";
    
                                case "chambollepock"
                                    i.tcp = arg1;
                                    i.scp = arg2;
                                    arg1_name = "tcp";
                                    arg2_name = "scp";
                            end
    
                            plt_name =  problem + ...
                                        "_maxiter_" + num2str(maxiter)+ ...
                                        "_gamma_" + num2str(gamma)+ ...
                                        arg1_name + num2str(arg1)+ ...
                                        arg2_name + num2str(arg2)+"_";
    
                            % Run Algorithm
                            x_out = salsa.solver(problem, algorithm, x_init, kernel, b, i);
                            
                            dir_res_alg = "./Results/" + algorithm + "/";
                            salsa.util.mkdir_if_no_dir(dir_res_alg)

                            % Store Figures
                            figs = findobj('Type', 'figure');
                            fig_num = fig_num + 1;
                            fig_collection(:,fig_num) = figs(1:2);
    
                            % Plot Deblurred Image
                            fig = figure('Name',"Deblurred Image #" + num2str(fig_num) );
                            imshow(x_out,[])
                            saveas(fig,dir_res_alg+plt_name+".png")
                            
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
    if mode ~= -1
        dir_merg_res = "./Results/Merged/";
        salsa.util.mkdir_if_no_dir(dir_merg_res);

        fig_name = ["Relative Objective Value", "Relative Error"];
        title_name = ["|f(x^k) - f(x^*)|/|f(x^*)|", "||x^k - x^*||/||x^*||"];
        for k = 1:2
            % Extract data
            fig_data = fig_collection(k,:);
    
            % Get line from figure data
            handleLine = findobj(fig_data,'type','line');
    
            % Make new figure 
            merged_fig = figure('Name',fig_name(k));
            ax = axes(merged_fig);
    
            % Plot all lines on the new figure
            hold on;
            for indx = 1:length(handleLine)
                line = handleLine(indx);
                plot(get(line,'XData'), get(line,'YData'), '--') ;
            end
    
            % Add title, label, legend
            title(ax,title_name(k))
            xlabel('Iteration Number'); ylabel(fig_name(k))
            box('on'); grid('on');
            legend(legends);
    
            % Set Y axis to log
            set(ax, 'Yscale','log', 'FontSize',14)

            % Save Figure
            merged_name = fig_name(k)+legends(k);
            merged_name = replace(merged_name,{' ', '\', '.'},"_");
            saveas(merged_fig,dir_merg_res+merged_name+".png")
        end
    end
end