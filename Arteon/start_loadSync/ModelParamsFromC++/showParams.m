function showParams( param_str )

if strcmp(param_str, 'Wxh')
    data = importfile_Wxh([param_str, '.txt'], 1, 50);
    
elseif strcmp(param_str, 'Whh')
    data = importfile_Whh([param_str, '.txt'], 1, 50);
    
elseif strcmp(param_str, 'Why')
    data = importfile_Why([param_str, '.txt'], 1, 50);
    
elseif strcmp(param_str, 'bh')
    data = importfile_bh([param_str, '.txt'], 1, 50);

elseif strcmp(param_str, 'by')
    data = importfile_by([param_str, '.txt'], 1, 50);
    
end

[n_rows, n_cols] = size(data);

width_max = 1;
height_max = 1;
val_max = max(data(:));
val_min = min(data(:));
val_abs_max = max(abs(data(:)));

figure;
for r = 1:n_rows
    for c = 1:n_cols
        val = data(r, c);
        val_scaling = val / val_abs_max;
        val_scaling = abs(val_scaling);
        % 有矩阵index得到坐标x,y
        x = (c-1);
        y = (r-1);
        if val >= 0
            rectangle('Position', [x + (1-val_scaling)/2, y + (1-val_scaling)/2, width_max*val_scaling, height_max*val_scaling], 'FaceColor', 'r');
        else
            rectangle('Position', [x + (1-val_scaling)/2, y + (1-val_scaling)/2, width_max*val_scaling, height_max*val_scaling], 'FaceColor', 'b');
        end
        
    end
end
title([param_str, ', maxVal: ', num2str(val_max), ', minVal: ', num2str(val_min), ', red: positive, blue: negative']);
grid on;
axis ij
axis equal

end

