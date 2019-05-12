%% visualization of Params RNN
% x = 1:2;
% y = 1:1;
% data = randn(1, 2);
% [X, Y] = meshgrid(x,y);
% 
% surf(X, Y, data);
% colorbar

% data = randn(1,2);
% mesh(data, 'LineWidth',10);
% colorbar

%%
% C = randn(1,4);
% pcolor(C);
% colormap summer
% 
% axis ij % reverse the coordinate system
% axis equal % 使得xy轴显示scale一样

%%
% clear;
% figure;
% plot(0:5, sin(0:5)); grid on;
% set(gca, 'xticklabel', []); % 将原有隐去
% xpos = 0:5;
% ypos = -ones(1, 6)-0.1;
% text(xpos, ypos, {'', 'aaaaa', 'bbbbb', 'ccccc', 'ddddd', 'eeeee'},...
%         'HorizontalAlignment', 'center',...
%         'rotation',70);

    % HorizontalAlignment 设置旋转轴，left right center
    % rotation 逆时针旋转
   
%%
% figure;
% plot(1:10,5.2*sin(1:10)); grid on;
% axis ij
% ys = get(gca, 'ytick');
% ys


