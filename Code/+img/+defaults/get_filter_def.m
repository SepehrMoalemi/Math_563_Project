%% Purpose: Get Default Padding for MATLAB imfilter
function padding = get_filter_def()
    %{
        Input array values outside the bounds of the array are computed by :
    
        %% 'symmetric':
            mirror-reflecting the array across the array border.
        
        %% 'replicate':
            assumed to equal the nearest array border value.
        
        %% 'circular':
            implicitly assuming the input array is periodic.
    %}
    padding = 'circular';
end

