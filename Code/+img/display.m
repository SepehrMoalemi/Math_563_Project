%% Purpose: Display Image using MATLAB imshow
function display(Img, fig_name, title_msg, is_gray, font_mult)
    arguments
        Img       
        fig_name  string
        title_msg string  = ""
        is_gray   logical = true
        font_mult double {mustBePositive(font_mult)} = 2
    end

    % Create Figure
    fig = figure('Name',fig_name);
    ax  = axes(fig);

    % Display Color/Gray Img
    if is_gray
        hIm = imshow(Img, [], 'Parent', ax);
    else
        hIm = image(Img, 'Parent', ax);
    end

    % Get Img Dims in Pixels
    title_txt = sprintf("[%d x %d]", hIm.XData(2), hIm.YData(2));

    % Check for title_msg
    if strcmp(title_msg, "") 
        title(ax, title_txt)
    else
        title(ax, [title_msg, title_txt])
    end

    % Change Font Multipliter
    ax.TitleFontSizeMultiplier = font_mult;
end

