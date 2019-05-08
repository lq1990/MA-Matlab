function showParams( param_str, ifaxisequal )
figure;

file = [param_str, '.txt'];

if strcmp(param_str, 'Wxh')
    data = importfile_Wxh(file);
    
    signalT = importfile_signal('signalsOfSync.txt');
    
    offset = 10;
    showXtickLabel(data, signalT, offset);
%     myxticklabel = {};
%     for i = 1:height(signalT)
%         signalName_cell = signalT.signalName(i);
%         signalName = signalName_cell{1,1};
%         myxticklabel = [myxticklabel, [num2str(i), ' ', signalName]];
%     end
% 
%     set(gca, 'xticklabel', []);
%     xpos = 1:17;
%     ypos = ones(1, 17)+ size(data, 1) + 10; % 设置显示text的 ypos
%     text(xpos, ypos,...
%             myxticklabel, ...
%             'HorizontalAlignment', 'center', ...
%             'rotation', 70,...
%             'FontWeight', 'Bold'); % HorizontalAlignment 设置旋转轴 right left center
    ylabel('neurons in hidden layer');
    
elseif strcmp(param_str, 'Whh')
    data = importfile_Whh(file);
    
elseif strcmp(param_str, 'Why')
    data = importfile_Why(file);
    
elseif strcmp(param_str, 'bh')
    data = importfile_bh(file);

elseif strcmp(param_str, 'by')
    data = importfile_by(file);
    
end

showMatrix(param_str,data, ifaxisequal, '');
% 
% [n_rows, n_cols] = size(data);
% 
% width_max = 1;
% height_max = 1;
% val_max = max(data(:));
% val_min = min(data(:));
% val_abs_max = max(abs(data(:)));
% 
% 
% for r = 1:n_rows
%     for c = 1:n_cols
%         val = data(r, c);
%         val_scaling = val / val_abs_max;
%         val_scaling = abs(val_scaling);
%         % 有矩阵index得到坐标x,y
%         x = c;
%         y = r;
%         
%         if val >= 0
%             facecolor = 'r';
%         else
%             facecolor = 'b';
%         end
%         
%         rectangle('Position', [x - width_max*val_scaling/2,... 
%                                         y - height_max*val_scaling/2, ...
%                                         width_max*val_scaling, ... 
%                                         height_max*val_scaling], ...
%                                     'FaceColor', facecolor);
%         
%     end
% end
% 
% title([param_str, ', maxVal: ', num2str(val_max), ', minVal: ', num2str(val_min), ', red: positive, blue: negative']);
% grid on;
% axis ij
% if ifaxisequal == 1
%     axis equal
% end

end

