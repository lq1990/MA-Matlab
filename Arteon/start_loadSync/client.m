clc; close all; clear;

addpath(genpath(pwd));

%% 1. 先运行 dataStruct.m，从 mat -> table , Arr
% 数据被过滤，下采样，按照场景时间做clip
dataStruct(); 
% 会write dataS, dataSArr。

%% 2. 从dataSArr 中找到每一列(即每一个signal)的最大值、最小值
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');

[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
% 有了 max min数值后， dataStruct 还需再次运行，以获得scaling后的数据
dataStruct(signalsMaxMinStruct); 

%% 4. plot
% 由于数据有更新，再次 load
load('.\DataFinalSave\dataSArrScaling.mat');
load('.\src\signalTable.mat');

mp = MyPlot(dataSArrScaling, signalTable, [1 : 20] , [12:16] ); % #3. range_id, #4. range_signal
mp.show();
