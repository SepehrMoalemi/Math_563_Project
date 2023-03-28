%% Purpose: Laod Image from File
function I = load(file_path, show)
    arguments
        file_path char {mustBeFile(file_path)}
        show      logical = true
    end
    
    I = imread(file_path);

    %% Display Image
    if show
        is_gray   = false;
        title_msg = "";
        img.display(I, 'Raw Image', title_msg, is_gray)
    end
end

