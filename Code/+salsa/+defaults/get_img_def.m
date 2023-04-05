%% Purpose: Give file_path of Default Image
function file_path = get_img_def(name)
    arguments
        name string {mustBeMember(name, ...
                                    ["cameraman", ...
                                     "mcgill", ...
                                     "salsa_default", ...
                                     "manwithhat"])} = "salsa_default"
    end
    %% Default Salsa Image Folder
    folder_path = '+salsa/+defaults/+images/';

    %% Find file with extension
    file = dir(folder_path + name + "*");

    %% Make file_path
    file_path = strcat(folder_path, file.name);

    %% Check if file exists
    assert(isfile(file_path),"Default Image not found!")
end