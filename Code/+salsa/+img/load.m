%% Purpose: Laod Image from File
function I = load(file_path, show)
    arguments
        file_path char {mustBeFile(file_path)}
        show      logical = true
    end
    
    I = imread(file_path);

    %% Display Image
    if show
        salsa.img.display(I, 'Raw Image')
    end
end