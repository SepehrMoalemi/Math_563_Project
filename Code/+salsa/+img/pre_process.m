%% Purpose: Do Preprocessing
% Convert the Image to Black and White
% Resize  the Image so that each pixel is between 0 and 1
% Display the resulting Image
function I = pre_process(I, grayscale, resize, show)
    arguments
        I         uint8
        grayscale logical = true
        resize    logical = true
        show      logical = true
    end
    
    %% Convert the Image to Black and White
    if grayscale
        I =  im2gray(I);
    end

    %% Resize the Image so each pixel is [0,1]
    if resize
        I = double(I(:,:,1));
        I_min = min(I(:));
        I = I - I_min;
        I_max = max(I(:));
        I = I/I_max;
    end
    
    %% Display the Resulting Image
    if show
        salsa.img.display(I, 'Image after Preprocessing')
    end
end