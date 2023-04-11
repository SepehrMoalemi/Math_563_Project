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
    gammal1s  = [0.15];                           % Put 0.01 if you want to see greater effect on blur reduction, but increase in noise.
    gammal2s  = [0.15];

    % ------ Optimization Algorithm Param ------ %
    % maxiters = 100*[5, 10, 20, 40];
    maxiters = 100*[1];
    % tcps = 1e-4*[50, 10, 5, 1]
    tcps = 1e-4*[1000];
    rhos = [0.1];

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

    % Choose Norm Type
    for problem = problems
        for indx = 1:length(gammal1s)
            % Set Problem Smoothing Params
            i.gammal1 = gammal1s(indx);
            i.gammal2 = gammal2s(indx);

            % Set Optimization Algorithm Param
            for maxiter = maxiters
                i.maxiter = maxiter;
                for tcp = tcps
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

                        close all;
                        
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