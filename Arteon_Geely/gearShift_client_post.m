
clear; close all; clc;

addpath(genpath(pwd));
rmpath(genpath(strcat(pwd, '\script\')));

% select params
rmpath(genpath(strcat(pwd, '\start_loadSync\ModelParamsFromC++\')));

%% Visulization of params of model

MyPlot.showParams('Wi', 1); % Wi = concat [Whi; Wxi]
MyPlot.showParams('Wy', 0);


%% plot loss accu
lossall = importfile_lossall('loss_all.txt');
accuracyeachepoch = importfile_accu('accuracy_each_epoch.txt');
lossmeaneachepoch = importfile_lossmean('loss_mean_each_epoch.txt');

figure;
subplot(221)
plot(lossall); grid on;
title('train(lambda 0.23): loss all');

subplot(223)
plot(lossmeaneachepoch, 'LineWidth',2); grid on;
title('train: loss mean each epoch');

subplot(222)
plot(accuracyeachepoch, 'r','LineWidth',2); grid on;
title('train: accuracy each epoch');

%% re-test
Wf = importfile_Wf('Wf.txt');
Wi = importfile_Wi('Wi.txt');
Wc = importfile_Wc('Wc.txt');
Wo = importfile_Wo('Wo.txt');
Wy = importfile_Wy('Wy.txt');
bf = importfile_bf('bf.txt');
bi = importfile_bi('bi.txt');
bc = importfile_bc('bc.txt');
bo = importfile_bo('bo.txt');
by = importfile_by('by.txt');

maxScore = 9.1;
minScore = 4.9;
numClasses = 10;

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
list_data = listStructTrain;
MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm train');

load('gearShift_loadSync\DataFinalSave\list_data\listStructCV.mat');
list_data = listStructCV;
MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm cv');

load('gearShift_loadSync\DataFinalSave\list_data\listStructTest.mat');
list_data = listStructTest;
MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm test');


%% figure out what the model really learnt, LSTM 1hidden

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');

Wf = importfile_Wf('Wf.txt');
Wi = importfile_Wi('Wi.txt');
Wc = importfile_Wc('Wc.txt');
Wo = importfile_Wo('Wo.txt');
bf = importfile_bf('bf.txt');
bi = importfile_bi('bi.txt');
bc = importfile_bc('bc.txt');
bo = importfile_bo('bo.txt');

margin = 0.8 ; % 'max.' excite the neuron

% train dataset
[neuronPatternS_lstm_positive, neuronPatternS_lstm_negative ]= NeuronPattern.neuronActTimeInSceLSTM1hidden(listStructTrain, Wf, Wi, Wc, Wo, bf, bi, bc, bo, margin);
neuronPatternSArr_lstm_positive = struct2array(neuronPatternS_lstm_positive);
neuronPatternSArr_lstm_negative = struct2array(neuronPatternS_lstm_negative);
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternS_lstm_positive' neuronPatternS_lstm_positive
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_positive' neuronPatternSArr_lstm_positive
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternS_lstm_negative' neuronPatternS_lstm_negative
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_negative' neuronPatternSArr_lstm_negative

% test dataset
load('gearShift_loadSync\DataFinalSave\list_data\listStructTest.mat');
[neuronPatternS_lstm_positive_test, neuronPatternS_lstm_negative_test ]= NeuronPattern.neuronActTimeInSceLSTM1hidden(listStructTest, Wf, Wi, Wc, Wo, bf, bi, bc, bo, margin);
neuronPatternSArr_lstm_positive_test = struct2array(neuronPatternS_lstm_positive_test);
neuronPatternSArr_lstm_negative_test = struct2array(neuronPatternS_lstm_negative_test);
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternS_lstm_positive_test' neuronPatternS_lstm_positive_test
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_positive_test' neuronPatternSArr_lstm_positive_test
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternS_lstm_negative_test' neuronPatternS_lstm_negative_test
save '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_negative_test' neuronPatternSArr_lstm_negative_test

%% plot neuron : pattern (part of scenarios), LSTM, train, positive

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
load('common\src\signalTable.mat');
load neuronPatternSArr_lstm_positive.mat

listStruct = listStructTrain;
range_neurons = [ 11, 19 ]; % 11+, 19-
range_id = [1:22]; % total trian 22 
subplotRows = 2; % subplot(subplotRows, subplotCols, ?)
subplotCols = 2;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_positive, signalTable, range_neurons, range_id, subplotRows, subplotCols );

%% plot neuron : pattern (part of scenarios), LSTM, train, negative

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
load('common\src\signalTable.mat');
load neuronPatternSArr_lstm_negative.mat

listStruct = listStructTrain;
range_neurons = [ 28, 38 ]; % 28+, 38-
range_id = [1:22]; % total trian 22 
subplotRows = 2; % subplot(subplotRows, subplotCols, ?)
subplotCols = 2;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_negative, signalTable, range_neurons, range_id, subplotRows, subplotCols );










