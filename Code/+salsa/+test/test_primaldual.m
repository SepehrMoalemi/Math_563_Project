%% Purpose: Batch test Chambolle-Pock Method
function test_primaldual(file_path)
    arguments
        file_path char {mustBeFile(file_path)}
    end
    % ------------- Image Param ---------------- %
    blur_types  = ["motion"];
    noise_types = ["none"]; %["gaussian"];
    pad_types   = ["replicate"];

    % ------------ Problem Param --------------- %
    problems = ["l2"];
    gammal1s  = [0];%1*[1.1];
    gammal2s  = 0.25*[1, 2, 4, 8];

    % ------ Optimization Algorithm Param ------ %
    maxiters = 100*[2];
    ts = 1e-3*[5];
    rhos = 1e-1*[5];

    % Load Image
    show_raw = false;
    I = img.load(file_path, show_raw);

    % Apply Preprocessing
    to_grayscale = true; 
    resize       = true;
    show_preproc = true;
    I = img.pre_process(I, to_grayscale, resize, show_preproc);

    % Generate All Combinations
    for blur_type = blur_types
        for noise_type = noise_types
            for pad_type = pad_types
                % Blur Image
                [kernel, b] = img.add_blur(I, blur_type, pad_type);
                plt_blur_name = blur_type+"_"+pad_type;
                dir_blur = "./Results/Blurring/";
                salsa.util.mkdir_if_no_dir(dir_blur)
                saveas(gcf,dir_blur+plt_blur_name+".png")

                % Add Noise
                b = img.add_noise(b, noise_type);
                plt_img = plt_blur_name+"_"+noise_type;
                dir_noise = "./Results/Noise/";
                salsa.util.mkdir_if_no_dir(dir_noise)
                saveas(gcf,dir_noise+plt_img+".png")

                % Set initial conditions
                [m, n] = size(b);
                x_intial.p0 = b;
                x_intial.q0 = zeros(m,n,3);
                
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
                                    x_out = salsa(problem,"douglasrachfordprimaldual",x_intial,kernel,b,i);
                                    dir_res_primaldual = "./Results/douglasrachfordprimaldual/";
                                    salsa.util.mkdir_if_no_dir(dir_res_primaldual)
                                    saveas(gcf,dir_res_primaldual+"err_"+plt_name+plt_img+".png")

                                    % Plot Deblurred Image
                                    fig = figure('Name','Deblurred Image' );
                                    imshow(x_out,[])
                                    saveas(fig,dir_res_primaldual+plt_name+plt_img+".png")

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
%                 break %<-------------------------------- Stop after 1 iter for now
            end
%             break %<------------------------------------ Stop after 1 iter for now
        end
%         break %<---------------------------------------- Stop after 1 iter for now
    end
end
