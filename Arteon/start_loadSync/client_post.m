% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

% 选择参数
rmpath([pwd, '/ModelParamsFromC++/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
% rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);

%% 矩阵可视化
MyPlot.showParams('Wxh', 0); % 第二个参数是 ifaxisequal
MyPlot.showParams('Whh', 1);
MyPlot.showParams('Why', 1);
MyPlot.showParams('bh', 1);
MyPlot.showParams('by', 1);

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

%% distribution of score of Arteon and Geely
scenarioTable_Arteon = load('scenarioTable');
scenario_Arteon = scenarioTable_Arteon.scenarioTable;
scores_Arteon = scenario_Arteon.score;

scenarioTableGeely = load('scenarioTable_Geely');
scenarioGeely = scenarioTableGeely.scenarioTable_Geely;
scoresGeely = scenarioGeely.score;

% scores_all = horzcat(scores_Arteon, scores_Geely);
% legend('Arteon','Geely');
figure;
subplot(121)
bar(scores_Arteon); grid on;
title('scores of Arteon');
ylim([0,10]);

subplot(122)
bar(scoresGeely); grid on;
title('scores  of Geely');
ylim([0,10]);


%% re-test the trainingData and scores
load('dataSArrScaling.mat');
load('signalTable.mat');

dataSArr = dataSArrScaling;
list_data_Arteon = SceSigDataTrans.allSce2ListStruct(dataSArr, signalTable); 

save '.\DataFinalSave\list_data_Arteon' list_data_Arteon

% ===== use matData and parameters to predict score =====
addpath(genpath(pwd));
rmpath([pwd, '\ModelParamsFromC++\DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
% rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);

% 场景进行 前传，计算score_class。使用到W b
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

fprintf('================================================\n');
list_data = list_data_Arteon;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

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


