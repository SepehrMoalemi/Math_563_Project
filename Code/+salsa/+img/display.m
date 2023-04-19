%% Purpose: Display Image using MATLAB imshow
function display(Img, fig_name, title_msg, font_mult)
    arguments
        Img       
        fig_name  string
        title_msg string  = ""
        font_mult double {mustBePositive(font_mult)} = 2
    end

    % Create Figure
    fig = figure('Name',fig_name);
    ax  = axes(fig);
    hIm = imshow(Img, 'Parent', ax);

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