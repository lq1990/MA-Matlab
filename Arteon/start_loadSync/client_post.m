% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

% select params
rmpath([pwd, '/ModelParamsFromC++/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.0073, accu 1, matDataZScore, listStructTrain']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 201, Adagrad, loss 0.03, accu 1, matDataZScore, listStructTrain, seed1']);
% rmpath([pwd, '/ModelParamsFromC++/lambda 0.19, train_cv_concat']);

%% Visulization of Matrix
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

%% re-test the trainingData and scores

% 场景进行 前传，计算score_class。使用到W b
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

load listStructTrain
list_data = listStructTrain;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

% re-test listStructCV
load listStructCV
list_data = listStructCV;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

% test listStructTest
load listStructTest
list_data = listStructTest;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

%% 另外找 10 个start场景，预测
% client_post_test


%% Anim, Visulization of computing process
load listStructTest

matData = listStructTest(1).matDataZScore; % idx_id
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

showComputeProcessHY(matData, Wxh, Whh, Why, bh, by);


%% figure out what RNN really learnt.
% what has each neuron learnt, 
% each neuron is a detector,
% each neuron has its own scope, it only focuses on particular patterns.
% We need to know which kind of pattern does each neuron recognize.
% i.e. in which patterns, a neuron will be activated or fired.
% !!! If we know the maps (neuron : pattern)
%       we can easily understand
%       how the classification works.

% 找到每个neuron被激活的pattern
load listStructTrain
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
bh = importfile_bh('bh.txt');
margin = 0.8 ; % 'max.' excite the neuron

[neuronPatternS_positive, neuronPatternS_negative ]= neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin);
neuronPatternSArr_positive = struct2array(neuronPatternS_positive);
neuronPatternSArr_negative = struct2array(neuronPatternS_negative);
save '.\DataFinalSave\neuronPatternS_positive' neuronPatternS_positive
save '.\DataFinalSave\neuronPatternSArr_positive' neuronPatternSArr_positive
save '.\DataFinalSave\neuronPatternS_negative' neuronPatternS_negative
save '.\DataFinalSave\neuronPatternSArr_negative' neuronPatternSArr_negative

% listStructTest
load listStructTest
[neuronPatternS_positive_listSTest, neuronPatternS_negative_listSTest] = neuronActTimeInSce( listStructTest, Wxh, Whh, bh, margin);
neuronPatternSArr_positive_listSTest  = struct2array(neuronPatternS_positive_listSTest);
neuronPatternSArr_negative_listSTest  = struct2array(neuronPatternS_negative_listSTest);
save '.\DataFinalSave\neuronPatternS_positive_listSTest' neuronPatternS_positive_listSTest
save '.\DataFinalSave\neuronPatternSArr_positive_listSTest' neuronPatternSArr_positive_listSTest
save '.\DataFinalSave\neuronPatternS_negative_listSTest' neuronPatternS_negative_listSTest
save '.\DataFinalSave\neuronPatternSArr_negative_listSTest' neuronPatternSArr_negative_listSTest

%% plot neuron : pattern (part of scenarios), listStructTrain
% 类比于：按signal，把所有场景plot。
% 此处：按照每个neuron，把场景激活时间段的 PC12 数据高亮，激活事件对应的信号即pattern
% 使用PC12，而非原始17个信号，为了可视化方便

load listStructTrain % 借助listStruct取得 id
load neuronPatternSArr_positive
% 一个neuron对应22个场景，把场景激活区域高亮，其它区域正常

listStruct = listStructTrain;
range_neurons = [ 41 ]; % 17-, 28-, 36+, 41+
range_id = [1 : 22];
plotNeuronPattern( listStruct, neuronPatternSArr_positive, range_neurons, range_id );

%% plot neuron : pattern (part of scenarios), listStructTest
load listStructTest % 借助listStruct取得 id
load neuronPatternSArr_positive_listSTest

listStruct = listStructTest;
range_neurons = [ 1:10 ]; % 28-, 36+
range_id = [1:7];
plotNeuronPattern( listStruct, neuronPatternSArr_positive_listSTest, range_neurons, range_id );


