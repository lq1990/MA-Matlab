% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

% select params
rmpath([pwd, '/ModelParamsFromC++/oneHidden/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
rmpath([pwd, '/ModelParamsFromC++/oneHidden/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);
rmpath([pwd, '/ModelParamsFromC++/oneHidden/100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.0073, accu 1, matDataZScore, listStructTrain']);
rmpath([pwd, '/ModelParamsFromC++/oneHidden/100hz, n_h 50, classes 10, alpha 0.1, epoches 201, Adagrad, loss 0.03, accu 1, matDataZScore, listStructTrain, seed1']);
rmpath([pwd, '/ModelParamsFromC++/oneHidden/lambda 0.19, train_cv_concat']);

% rmpath([pwd, '/ModelParamsFromC++/twoHidden/epoches 501, h_hidden 50 50, listStructTrainCV/']);

%% Visulization of Matrix
% MyPlot.showParams('Wxh', 0); % 第二个参数是 ifaxisequal
% MyPlot.showParams('Whh', 1);
% MyPlot.showParams('Why', 1);
% MyPlot.showParams('bh', 1);
% MyPlot.showParams('by', 1);

MyPlot.showParams('Wxh1', 0);
MyPlot.showParams('Wh1h1', 1);
MyPlot.showParams('Wh1h2', 1);
MyPlot.showParams('Wh2h2', 1);
MyPlot.showParams('Wh2y', 1);
MyPlot.showParams('bh1', 1);
MyPlot.showParams('bh2', 1);
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
% Wxh = importfile_Wxh('Wxh.txt');
% Whh = importfile_Whh('Whh.txt');
% Why = importfile_Why('Why.txt');
% bh = importfile_bh('bh.txt');
% by = importfile_by('by.txt');

Wxh1 = importfile_Wxh1('Wxh1.txt');
Wh1h1 = importfile_Wh1h1('Wh1h1.txt');
Wh1h2 = importfile_Wh1h2('Wh1h2.txt');
Wh2h2 = importfile_Wh2h2('Wh2h2.txt');
Wh2y = importfile_Why('Wh2y.txt');
bh1 = importfile_bh('bh1.txt');
bh2 = importfile_bh('bh2.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

load listStructTrain
list_data = listStructTrain;
% MyPredict.printAllOneHidden( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );
MyPredict.printAllTwoHidden( list_data, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by, maxScore, minScore, numClasses );

% re-test listStructCV
load listStructCV
list_data = listStructCV;
% MyPredict.printAllOneHidden( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );
MyPredict.printAllTwoHidden( list_data, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by, maxScore, minScore, numClasses );

% test listStructTest
load listStructTest
list_data = listStructTest;
% MyPredict.printAllOneHidden( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );
MyPredict.printAllTwoHidden( list_data, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by, maxScore, minScore, numClasses );

%% 另外找 10 个start场景，预测
% client_post_test


%% Anim, one hidden layer, Visualization of computing process
load listStructTest

matData = listStructTest(2).matDataZScore; % idx_id
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

showComputeProcessHY1Hidden(matData, Wxh, Whh, Why, bh, by);

%% Anim, two hidden layers, Visualiazation
load listStructTrain

matData = listStructTrain(1).matDataZScore; % idx_id
Wxh1 = importfile_Wxh1('Wxh1.txt');
Wh1h1 = importfile_Wh1h1('Wh1h1.txt');
Wh1h2 = importfile_Wh1h2('Wh1h2.txt');
Wh2h2 = importfile_Wh2h2('Wh2h2.txt');
Wh2y = importfile_Why('Wh2y.txt');
bh1 = importfile_bh('bh1.txt');
bh2 = importfile_bh('bh2.txt');
by = importfile_by('by.txt');

showComputeProcessHY2Hidden(matData, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by);


%% figure out what RNN really learnt. 1 hidden layer
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

[neuronPatternS_positive, neuronPatternS_negative ]= neuronActTimeInSce1hidden( listStructTrain, Wxh, Whh, bh, margin);
neuronPatternSArr_positive = struct2array(neuronPatternS_positive);
neuronPatternSArr_negative = struct2array(neuronPatternS_negative);
save '.\DataFinalSave\neuronPatternS_positive' neuronPatternS_positive
save '.\DataFinalSave\neuronPatternSArr_positive' neuronPatternSArr_positive
save '.\DataFinalSave\neuronPatternS_negative' neuronPatternS_negative
save '.\DataFinalSave\neuronPatternSArr_negative' neuronPatternSArr_negative

% listStructTest
load listStructTest
[neuronPatternS_positive_listSTest, neuronPatternS_negative_listSTest] = neuronActTimeInSce1hidden( listStructTest, Wxh, Whh, bh, margin);
neuronPatternSArr_positive_listSTest  = struct2array(neuronPatternS_positive_listSTest);
neuronPatternSArr_negative_listSTest  = struct2array(neuronPatternS_negative_listSTest);
save '.\DataFinalSave\neuronPatternS_positive_listSTest' neuronPatternS_positive_listSTest
save '.\DataFinalSave\neuronPatternSArr_positive_listSTest' neuronPatternSArr_positive_listSTest
save '.\DataFinalSave\neuronPatternS_negative_listSTest' neuronPatternS_negative_listSTest
save '.\DataFinalSave\neuronPatternSArr_negative_listSTest' neuronPatternSArr_negative_listSTest

%% neuronPattern of 2 hidden layers
% train dataset
load listStructTrain
Wxh1 = importfile_Wxh1('Wxh1.txt');
Wh1h1 = importfile_Wh1h1('Wh1h1.txt');
Wh1h2 = importfile_Wh1h2('Wh1h2.txt');
Wh2h2 = importfile_Wh2h2('Wh2h2.txt');
bh1 = importfile_bh('bh1.txt');
bh2 = importfile_bh('bh2.txt');
margin = 0.8 ; % 'max.' excite the neuron

[neuronPatternS_twoHidden_positive, neuronPatternS_twoHidden_negative ]= neuronActTimeInSce2hidden( listStructTrain, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin);
neuronPatternSArr_twoHidden_positive = struct2array(neuronPatternS_twoHidden_positive);
neuronPatternSArr_twoHidden_negative = struct2array(neuronPatternS_twoHidden_negative);
save '.\DataFinalSave\neuronPatternS_twoHidden_positive' neuronPatternS_twoHidden_positive
save '.\DataFinalSave\neuronPatternSArr_twoHidden_positive' neuronPatternSArr_twoHidden_positive
save '.\DataFinalSave\neuronPatternS_twoHidden_negative' neuronPatternS_twoHidden_negative
save '.\DataFinalSave\neuronPatternSArr_twoHidden_negative' neuronPatternSArr_twoHidden_negative

% test dataset
load listStructTest
[neuronPatternS_twoHidden_positive_test, neuronPatternS_twoHidden_negative_test ]= neuronActTimeInSce2hidden( listStructTest, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin);
neuronPatternSArr_twoHidden_positive_test = struct2array(neuronPatternS_twoHidden_positive_test);
neuronPatternSArr_twoHidden_negative_test = struct2array(neuronPatternS_twoHidden_negative_test);
save '.\DataFinalSave\neuronPatternS_twoHidden_positive_test' neuronPatternS_twoHidden_positive_test
save '.\DataFinalSave\neuronPatternSArr_twoHidden_positive_test' neuronPatternSArr_twoHidden_positive_test
save '.\DataFinalSave\neuronPatternS_twoHidden_negative_test' neuronPatternS_twoHidden_negative_test
save '.\DataFinalSave\neuronPatternSArr_twoHidden_negative_test' neuronPatternSArr_twoHidden_negative_test

%% plot neuron : pattern (part of scenarios), listStructTrain. 1 hidden layer
% 类比于：按signal，把所有场景plot。
% 此处：按照每个neuron，把场景激活时间段的 PC12 数据高亮，激活事件对应的信号即pattern
% 使用PC12，而非原始17个信号，为了可视化方便。
% 改为：对raw signals plot，易于对原始数据理解

load listStructTrain % 借助listStruct取得 id
load neuronPatternSArr_positive
% 一个neuron对应22个场景，把场景激活区域高亮，其它区域正常

listStruct = listStructTrain;
range_neurons = [ 17, 28, 36, 41 ]; % 17-, 28-, 36+, 41+
range_id = [1 : 22];
plotNeuronPatternPC12( listStruct, neuronPatternSArr_positive, range_neurons, range_id );

%% plot neuron : pattern (part of scenarios), listStructTest. 1 hidden layer, PC
load listStructTest % 借助listStruct取得 id
load neuronPatternSArr_positive_listSTest

listStruct = listStructTest;
range_neurons = [ 1:10 ]; % 28-, 36+
range_id = [1:7];
plotNeuronPatternPC12( listStruct, neuronPatternSArr_positive_listSTest, range_neurons, range_id );

%% plot neuron : pattern (part of scenarios), listStructTest. 2 hidden layer, raw signals
load listStructTrain
load signalTable
load neuronPatternSArr_twoHidden_positive

listStruct = listStructTrain;
range_neurons = 50 + [ 1, 19 ]; % 51, 69
range_id = [1:22]; % total trian 22 

plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_twoHidden_positive, signalTable, range_neurons, range_id );




