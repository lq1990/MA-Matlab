% 关于采样频率
% 原始是 100hz，下采样后是10hz。下采样方法：直接每隔一小段取一个数值。
% 不同采样频率，t_end不同。应微调 idx_t_begin t_end 以确保 汽车启动时FP是0 且启动结束也是0.
% 上采样时，一定要注意：sync_t 的extend，不能是重复前一个t。

% Arteon: id 10xxx
% Geely  : id 20xxx

clc; close all; clear;

addpath(genpath(pwd));

%% 1. 先运行 dataStruct.m，从 mat -> table , Arr
% 数据被过滤，下采样，按照场景时间做clip
scenarioFile = 'scenariosOfSync.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % 上采样 100hz
car_type = 'Arteon';
[dataS, dataSArr, scenarioTable, signalTable]  = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type); 
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable
save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

%% 2. 从dataSArr 中找到每一列(即每一个signal)的最大值、最小值
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = MyNormalization.findSignalsMaxMin(dataSArr, signalTable);
% 存储，为了test时也要用到
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]= MyNormalization.minMaxScaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
plotscaling = 0;
range_id = [1:19]; % total_id: 19
range_signal = [1:5]; % total_signal: 17

if plotscaling==1
    load('.\DataFinalSave\dataSArrScaling.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArrScaling, signalTable, range_id , range_signal, 10 ); 
    mp.show();
else
    load('.\DataFinalSave\dataSArr.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArr, signalTable, range_id , range_signal, 10 ); 
    mp.show();
end

clearvars mp plotscaling range_id range_signal sampling_factor;

%% PCA
