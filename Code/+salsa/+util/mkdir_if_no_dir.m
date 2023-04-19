%% Purpose: Make directory if it does not exist
function mkdir_if_no_dir(dir)
    arguments
        dir string
    end
    if ~exist(dir, 'dir')
       mkdir(dir)
    end
end