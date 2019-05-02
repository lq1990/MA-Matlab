% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

%% DIY ������ӻ�
showParams('Wxh', 0); % �ڶ��������� ifaxisequal
showParams('Whh', 1);
showParams('Why', 1);
showParams('bh', 1);
showParams('by', 1);

%% plot loss accu
lossall = importfile_lossall('loss_all.txt');
accuracyeachepoch = importfile_accu('accuracy_each_epoch.txt');
lossmeaneachepoch = importfile_lossmean('loss_mean_each_epoch.txt');

figure;
subplot(221)
plot(lossall); grid on;
title('loss all');

subplot(223)
plot(lossmeaneachepoch, 'LineWidth',2); grid on;
title('loss mean each epoch');

subplot(222)
plot(accuracyeachepoch, 'r','LineWidth',2); grid on;
title('accuracy each epoch');

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
% axis equal % ʹ��xy����ʾscaleһ��

%%
% clear;
% figure;
% plot(0:5, sin(0:5)); grid on;
% set(gca, 'xticklabel', []); % ��ԭ����ȥ
% xpos = 0:5;
% ypos = -ones(1, 6)-0.1;
% text(xpos, ypos, {'', 'aaaaa', 'bbbbb', 'ccccc', 'ddddd', 'eeeee'},...
%         'HorizontalAlignment', 'center',...
%         'rotation',70);

    % HorizontalAlignment ������ת�ᣬleft right center
    % rotation ��ʱ����ת
   
%%
% figure;
% plot(1:10,5.2*sin(1:10)); grid on;
% axis ij
% ys = get(gca, 'ytick');
% ys


