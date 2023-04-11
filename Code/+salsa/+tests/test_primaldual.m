%% Purpose: Batch test Chambolle-Pock Method
function test_primaldual(file_path)
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
    problems = ["l1"];
    gammal1s  = 1*[0.2];
    gammal2s  = 0.25*[1, 2, 4, 8];

    % ------ Optimization Algorithm Param ------ %
    maxiters = 100*[10];
    ts = 1e0*[5];
    rhos = 1e-1*[4];

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
    x_intial.p0 = b;
    x_intial.q0 = zeros(m,n,3);

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
                for t = ts
                    i.tprimaldualdr  = t;
                    for rho = rhos
                        i.rhoprimaldualdr  = rho;
                        
                        plt_name =  problem + ...
                                    "_maxiter_" + num2str(maxiter)+ ...
                                    "_gamma_" + num2str(i.gammal1)+ ...
                                    "_t_" + num2str(t)+ ...
                                    "_rho_" + num2str(rho)+"_";

                        % Run chambollepock
                        x_out = salsa.solver(problem,"douglasrachfordprimaldual",x_intial,kernel,b,i);
                        dir_res_primaldual = "./Results/douglasrachfordprimaldual/";
                        salsa.util.mkdir_if_no_dir(dir_res_primaldual)
                        % saveas(gcf,dir_res_primaldual+"err_"+plt_name+".png")

                        % Plot Deblurred Image
                        fig = figure('Name','Deblurred Image' );
                        imshow(x_out,[])
                        % saveas(fig,dir_res_primaldual+plt_name+".png")

                        % close all;
                        
%                                     break %<------------- Stop after 1 iter for now
                    end
%                                 break %<---------------- Stop after 1 iter for now
                end
%                             break %<-------------------- Stop after 1 iter for now
            end
%                         break %<------------------------ Stop after 1 iter for now
        end
%                     break %<---------------------------- Stop after 1 iter for now
    end
end
