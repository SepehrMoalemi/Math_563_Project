%% Purpose: Batch test ADMM Method
function test_admm(file_path)
    arguments
        file_path char {mustBeFile(file_path)}
    end
    % ------------- Image Param ---------------- %
    blur_type  = "motion";
    blur_arg   = {};
    noise_type = "gaussian";
    noise_arg  = {};
    pad_type   = "circular";

    % ------------ Problem Param --------------- %
    problems = ["l1", "l2"];
    %{
        Tested as 
            l1: [0.09 0.08 0.07 0.06]
            l2: [0.2 0.1 0.008 0.005]
            rhos:
            tadmm:
            maxiters:
    %}
    gammal1s  = [0.08 0.09];                
    gammal2s  = [0.005 0.006];          % Must refer to the indexes of gammal1s

    % ------ Optimization Algorithm Param ------ %
    % maxiters = 100*[5, 10, 20, 40];
    maxiters = 6*[1];
    % tcps = 1e-4*[50, 10, 5, 1]
    tadmm = 1e-4*[1000];
    rhos = [0.9];

    % Load Image
    show_raw = false;
    I = salsa.img.load(file_path, show_raw);

    % Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = true;
    I = salsa.img.pre_process(I, to_grayscale, resize, show_preproc);

    %% Generate All Combinations
    % Blur Image
    [kernel, b] = salsa.img.add_blur(I, blur_type, blur_arg, pad_type);

    % Add Noise
    b = salsa.img.add_noise(b, noise_type, noise_arg);

    % Set initial conditions
    [m, n] = size(b);
    x_initial.x0 = b;
    x_initial.y0 = zeros(m,n,3);
    x_initial.z0 = zeros(m,n,3);
    x_initial.u0 = b;
    x_initial.w0 = b;
    
    x_initial.x_original = I;
    
    i.comb_plot = true;
    if i.comb_plot == true
        fig_l1 = figure(100);legend;hold on; 
        fig_l2 = figure(200);legend;hold on;
    end

    % Choose problem
    for problem = problems
        if problem == "l1" && i.comb_plot == true
            i.fig = fig_l1;
        elseif problem == "l2" && i.comb_plot == true
            i.fig = fig_l2;
        end
        for indx = 1:length(gammal1s)
            % Set Problem Smoothing Params
            i.gammal1 = gammal1s(indx);
            i.gammal2 = gammal2s(indx);
            

            % Set Optimization Algorithm Param
            for maxiter = maxiters
                i.maxiter = maxiter;
                for tcp = tadmm
                    i.tcp = tcp;
                    for rho = rhos
                        i.rho = rho;
                        
                        plt_name =  problem + ...
                                    "_maxiter_" + num2str(maxiter)+ ...
                                    "_gamma_" + num2str(i.gammal1)+ ...
                                    "_tcp_" + num2str(tcp)+ ...
                                    "_rho_" + num2str(rho)+"_";

                        % Run chambollepock
                        x_out = salsa.solver(problem,"admm",x_initial,kernel,b,i);
                        dir_res_admm = "./Results/admm/";
                        salsa.util.mkdir_if_no_dir(dir_res_admm)
                        saveas(gcf,dir_res_admm+"err_"+plt_name+".png")

                        % Plot Deblurred Image
                        fig = figure('Name','Deblurred Image' );
                        imshow(x_out,[])
                        saveas(fig,dir_res_admm+plt_name+".png")

                        % close all;
                        
                        % break %<------------- Stop after 1 iter for now
                    end
                    % break %<---------------- Stop after 1 iter for now
                end
                % break %<-------------------- Stop after 1 iter for now
            end
            % break %<------------------------ Stop after 1 iter for now
        end
        % break %<---------------------------- Stop after 1 iter for now
    end
end