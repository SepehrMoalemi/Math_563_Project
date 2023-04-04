function mkdir_if_no_dir(dir)
    if ~exist(dir, 'dir')
       mkdir(dir)
    end
end

