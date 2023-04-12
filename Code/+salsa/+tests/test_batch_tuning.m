%% Purpose: Batch test tuning parameters
function test_batch_tuning(file_path, algorithm, ...
                            problems, gammal1s, gammal2s, ...
                            arg1s, arg2s, ...
                            maxIters, sample_rate, ...
                            blur_type, blur_arg, ...
                            noise_type, noise_arg, ...
                            pad_type)
    arguments
        file_path char {mustBeFile(file_path)}
        algorithm string {mustBeMember(algorithm, ...
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

    %% Choose Norm Type
    for problem = problems
        for indx = 1:length(gammal1s)
            % Set Problem Smoothing Params
            i.gammal1 = gammal1s(indx);
            i.gammal2 = gammal2s(indx);

            switch problem
                case 'l1'
                    gamma = i.gammal1;

                case 'l2'
                    gamma = i.gammal2;
            end

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
                        saveas(gcf,dir_res_chamb+"err_"+plt_name+".png")

                        % Plot Deblurred Image
                        fig = figure('Name','Deblurred Image' );
                        imshow(x_out,[])
                        saveas(fig,dir_res_chamb+plt_name+".png")
                    end
                end
            end
        end
    end
end