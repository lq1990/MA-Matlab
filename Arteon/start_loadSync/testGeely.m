% use rnn-parameters which trained in C++ to predict new data of Geely
clear; close all; clc;

%% txt 2 dataStruct
% 注意Geely采样频率的不同 于Arteon, 在 tryASignalAllData 中修改
sampling_factor = 100;
dataStructGeely(sampling_factor);

% save struct in DataFinalSave

%% scaling, use min-max val of training data
load('signalsMaxMinStruct.mat');
load('signalTable_Geely');
load dataSArr_Geely

[dataSScaling_Geely, dataSArrScaling_Geely] = scaling(dataSArr_Geely, signalsMaxMinStruct, signalTable_Geely);
save '.\DataFinalSave\dataSScaling_Geely' dataSScaling_Geely
save '.\DataFinalSave\dataSArrScaling_Geely' dataSArrScaling_Geely

%% dataStruct 2 list_data_Geely
load('dataSArrScaling_Geely.mat');
load('signalTable_Geely.mat');

dataSArr = dataSArrScaling_Geely;
signalTable = signalTable_Geely;

list_data_Geely = allSce2ListStruct(dataSArr, signalTable); % [struct{id, score, matData}, struct, ...]
clearvars dataSArr dataSArrScaling_Geely signalTable signalTable_Geely

%% use matData and parameters to predict score
addpath(genpath(pwd));
rmpath([pwd, '\ModelParamsFromC++\DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);

% 写个 fn，对单个场景进行 前传，计算score。使用到W b


%% plot
plotscaling = 0 ;
range_id = [1:6]; % total_id: 6
range_signal = [1:5]; % total_signal: 17

amp = 5; % for plot
if plotscaling==1
    load('.\DataFinalSave\dataSArrScaling_Geely.mat');
    load('.\test\signalTable_Geely.mat');
    mp = MyPlot(dataSArrScaling_Geely, signalTable_Geely, range_id , range_signal, amp ); 
    mp.show();
else
    load('.\DataFinalSave\dataSArr_Geely.mat');
    load('signalTable_Geely.mat');
    mp = MyPlot(dataSArr_Geely, signalTable_Geely, range_id , range_signal, amp); 
    mp.show();
end

clearvars mp plotscaling range_id range_signal sampling_factor;