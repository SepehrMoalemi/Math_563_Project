%% Purpose: Batch test douglasrachfordprimal
function test_douglasrachfordprimal(file_path)
    arguments
        file_path char {mustBeFile(file_path)}
    end
    % ------------- Image Param ---------------- %
    blur_type  = "gaussian";
    blur_arg   = {};
    noise_type = "gaussian";
    noise_arg  = {};
    pad_type   = "circular";

    % ------------ Problem Param --------------- %
    problems = ["l1", "l2"];
    gammal1s  = 0.18*[1, 2, 4, 8];
    gammal2s  = 0.50*[1, 2, 4, 8];
    tprimaldrs = 1e-3*[1, 10];
    rhoprimaldrs = [1, 2];

    % ------ Optimization Algorithm Param ------ %
    maxiters = 25*[5, 10, 20, 40];

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
    x_intial.z1 = b;
    x_intial.z2 = zeros(m,n,3);

    x_initial.x_original = I;
    
    i.comb_plot = false;
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
                for tprimaldr = tprimaldrs
                    i.tprimaldr = tprimaldr;
                    for rhoprimaldr = rhoprimaldrs
                        i.rhoprimaldr = rhoprimaldr;
                        
                        plt_name =  problem + ...
                                    "_maxiter_" + num2str(maxiter)+ ...
                                    "_gamma_" + num2str(i.gammal1)+"_";

                        % Run douglasrachfordprimal
                        x_out = salsa.solver(problem,"douglasrachfordprimal",x_intial,kernel,b,i);
                        dir_res_douglasprimal = "./Results/douglasrachfordprimal/";
                        salsa.util.mkdir_if_no_dir(dir_res_douglasprimal)
                        saveas(gcf,dir_res_douglasprimal+"err_"+plt_name+".png")

                        % Plot Deblurred Image
                        fig = figure('Name','Deblurred Image' );
                        imshow(x_out,[])
                        saveas(fig,dir_res_douglasprimal+plt_name+".png")
                        %close all;
                        
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