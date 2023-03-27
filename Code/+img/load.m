%% Purpose: Laod Image from File
function I = load(file_path)
    arguments
        file_path char {mustBeFile(file_path)}
    end
    I = imread(file_path);
end

