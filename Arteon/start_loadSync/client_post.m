% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

% ѡ�����
rmpath([pwd, '/ModelParamsFromC++/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
% rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);

%% ������ӻ�
MyPlot.showParams('Wxh', 0); % �ڶ��������� ifaxisequal
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

% �������� ǰ��������score_class��ʹ�õ�W b
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

list_data = list_data_Arteon;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

%% test Geely


