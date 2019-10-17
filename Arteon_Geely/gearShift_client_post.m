% gearShiftUp

clear; close all; clc;

addpath(genpath(pwd));
rmpath(genpath(strcat(pwd, '\script\')));

% select params
rmpath(genpath(strcat(pwd, '\start_loadSync\ModelParams\')));
rmpath(genpath(strcat(pwd, '\gearShiftUp_loadSync\ModelParams\')));
rmpath(genpath(strcat(pwd, '\gearShiftDown_loadSync\ModelParams\')));

%% Visulization of params of model

MyPlot.showParams('Wi1', 0); % Wi = concat [Whi; Wxi]
xlim([0, 50]);
ylim([50, 67]);
xlabel('index of neuron');
ylabel('index of feature');
set(gca, 'FontSize', 10);
set(gca,'fontweight','bold');

MyPlot.showParams('Whh1', 0);
xlabel('class');
ylabel('neuron');
set(gca, 'FontSize', 10);
set(gca,'fontweight','bold');



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
Wf = importfile_Wf1('Wf1.txt');
Wi = importfile_Wi1('Wi1.txt');
Wc = importfile_Wc1('Wc1.txt');
Wo = importfile_Wo1('Wo1.txt');
Wy = importfile_Whh1('Whh1.txt');

bf = importfile_bf1('bf1.txt');
bi = importfile_bi1('bi1.txt');
bc = importfile_bc1('bc1.txt');
bo = importfile_bo1('bo1.txt');
by = importfile_bhh1('bhh1.txt');

maxScore = 10.0;
minScore = 4.0;
numClasses = 5;

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
list_data = listStructTrain;
MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm train');

% load('gearShiftUp_loadSync\DataFinalSave\list_data\listStructCV.mat');
% list_data = listStructCV;
% MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm cv');

load('gearShift_loadSync\DataFinalSave\list_data\listStructTest.mat');
list_data = listStructTest;
MyPredict.printAllLSTMOneHidden(list_data, Wf, Wi, Wc, Wo, Wy, bf, bi, bc, bo, by, maxScore, minScore, numClasses, 'lstm test');


%% figure out what the model really learnt, LSTM 1hidden

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');

Wf = importfile_Wf1('Wf1.txt');
Wi = importfile_Wi1('Wi1.txt');
Wc = importfile_Wc1('Wc1.txt');
Wo = importfile_Wo1('Wo1.txt');
Wy = importfile_Whh1('Whh1.txt');

bf = importfile_bf1('bf1.txt');
bi = importfile_bi1('bi1.txt');
bc = importfile_bc1('bc1.txt');
bo = importfile_bo1('bo1.txt');
by = importfile_bhh1('bhh1.txt');

margin = 0.6 ; % 'max.' excite the neuron

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
close all;

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
load('common\src\signalTable.mat');
load '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_positive'

listStruct = listStructTrain;
range_neurons = [ 7 ]; %
range_id = [ 21 : 26, 28:31 ]; % total train
subplotRows = 1; % subplot(subplotRows, subplotCols, ?)
subplotCols = 1;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_positive, signalTable, range_neurons, range_id, subplotRows, subplotCols );


%% plot neuron : pattern (part of scenarios), LSTM, train, negative
close all;

load('gearShift_loadSync\DataFinalSave\list_data\listStructTrain.mat');
load('common\src\signalTable.mat');
load '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_negative.mat'

listStruct = listStructTrain;
range_neurons = [ 46 ]; % negative 36 -> class 1
range_id = [ 1:10 ]; % total trian 22 
subplotRows = 1; % subplot(subplotRows, subplotCols, ?)
subplotCols = 1;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_negative, signalTable, range_neurons, range_id, subplotRows, subplotCols );


%% plot neuron : pattern (part of scenarios), LSTM, test, positive

load('gearShift_loadSync\DataFinalSave\list_data\listStructTest.mat');
load('common\src\signalTable.mat');
load '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_positive_test.mat'

listStruct = listStructTest;
range_neurons = [ 2]; %
range_id = [1:10]; % total 
subplotRows = 1; % subplot(subplotRows, subplotCols, ?)
subplotCols = 2;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_positive_test, signalTable, range_neurons, range_id, subplotRows, subplotCols );



%% plot neuron : pattern (part of scenarios), LSTM, test, negative
close all;

load('gearShift_loadSync\DataFinalSave\list_data\listStructTest.mat');
load('common\src\signalTable.mat');
load '.\gearShift_loadSync\DataFinalSave\neuronPattern\neuronPatternSArr_lstm_negative_test.mat'

listStruct = listStructTest;
range_neurons = [26 ]; % 
range_id = [1:20]; % total trian 22 
subplotRows = 2; % subplot(subplotRows, subplotCols, ?)
subplotCols = 2;

NeuronPattern.plotNeuronPatternRawSignals( listStruct, neuronPatternSArr_lstm_negative_test, signalTable, range_neurons, range_id, subplotRows, subplotCols );





