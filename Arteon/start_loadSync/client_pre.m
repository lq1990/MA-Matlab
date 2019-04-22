% 关于采样频率
% 原始是 100hz，下采样后是10hz。下采样方法：直接每隔一小段取一个数值。
% 不同采样频率，t_end不同。应微调 idx_t_begin t_end 以确保 汽车启动时FP是0 且启动结束也是0.
% 上采样时，一定要注意：sync_t 的extend，不能是重复前一个t。

clc; close all; clear;

addpath(genpath(pwd));

%% 1. 先运行 dataStruct.m，从 mat -> table , Arr
% 数据被过滤，下采样，按照场景时间做clip
dataStruct(); 
% 会 save dataS, dataSArr。

%% 2. 从dataSArr 中找到每一列(即每一个signal)的最大值、最小值
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
% 存储，为了test时也要用到
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
plotscaling = 1;
range_id = [10:20];
range_signal = [4,10];

if plotscaling==1
    load('.\DataFinalSave\dataSArrScaling.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArrScaling, signalTable, range_id , range_signal ); 
    mp.show();
else
    load('.\DataFinalSave\dataSArr.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArr, signalTable, range_id , range_signal  ); 
    mp.show();
end

clearvars mp plotscaling range_id range_signal;
