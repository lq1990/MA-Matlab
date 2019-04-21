% after training model in C++
clear; close all; clc;

addpath(genpath(pwd));

%% DIY 矩阵可视化
showParams('Wxh');
showParams('Whh');
showParams('Why');
showParams('bh');
showParams('by');

%% plot loss accu
lossall = importfile_lossall('loss_all.txt');
accuracyeachepoch = importfile_accu('accuracy_each_epoch.txt');
lossmeaneachepoch = importfile_lossmean('loss_mean_each_epoch.txt');

figure;
subplot(221)
plot(lossall); grid on;
title('loss all');

subplot(223)
plot(lossmeaneachepoch); grid on;
title('loss mean each epoch');

subplot(222)
plot(accuracyeachepoch); grid on;
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
% axis equal % 使得xy轴显示scale一样


