%% Purpose: Display Image using MATLAB imshow
function display(Img, fig_name, title_msg, font_mult)
    arguments
        Img       double
        fig_name  string
        title_msg string = ""
        font_mult double {mustBePositive(font_mult)} = 2
    end
    figure('Name',fig_name)
    hIm = imshow(Img,[]);
    title_txt = sprintf("[%d x %d]", hIm.XData(2), hIm.YData(2));
    if strcmp(title_msg, "") 
        title(title_txt)
    else
        title([title_txt,title_msg])
    end
    ax = gca;
    ax.TitleFontSizeMultiplier = font_mult;
end

