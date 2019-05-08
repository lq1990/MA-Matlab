function showMatrix(param_str, data,  ifaxisequal, titleStr)
%PLOTMATRIX Summary of this function goes here
%   Detailed explanation goes here

if strcmp(param_str, 'cov')
    signalT = importfile_signal('signalsOfSync.txt');
    offset = 1;
    showXtickLabel(data, signalT, offset);
end

if strcmp(param_str, 'eigenvector')
    signalT = importfile_signal('signalsOfSync.txt');
    offset = 1;
    showYtickLabel(data, signalT, offset);
end


[n_rows, n_cols] = size(data);

width_max = 1;
height_max = 1;
val_max = max(data(:));
val_min = min(data(:));
val_abs_max = max(abs(data(:)));


for r = 1:n_rows
    for c = 1:n_cols
        val = data(r, c);
        val_scaling = val / (val_abs_max+ 1e-8);
        val_scaling = abs(val_scaling);
        % 有矩阵index得到坐标x,y
        x = c;
        y = r;
        
        if val >= 0
            facecolor = 'r';
        else
            facecolor = 'b';
        end
        
%         fprintf('row: %d, col: %d\n', r, c);
%         fprintf('width_max: %d\n',width_max);
%         fprintf('val_scaling: %d\n',val_scaling);
%         fprintf('height_max: %d\n',height_max);

        rectangle('Position', [x - width_max*val_scaling/2,... 
                                        y - height_max*val_scaling/2, ...
                                        width_max*val_scaling, ... 
                                        height_max*val_scaling], ...
                                    'FaceColor', facecolor);
        
    end
end

title([titleStr, ' ', param_str, ', maxVal: ', num2str(val_max), ', minVal: ', num2str(val_min), ', red: positive, blue: negative']);
grid on;
axis ij
if ifaxisequal == 1
    axis equal
end

end

