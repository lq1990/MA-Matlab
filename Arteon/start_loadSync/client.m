clc; close all; clear;

addpath(genpath(pwd));

%% 1. 先运行 dataStruct.m，从 mat -> table , Arr
% 数据被过滤，下采样，按照场景时间做clip
[tmp_asignal_val_factor] = dataStruct0(); 
% 会 save dataS, dataSArr。

%% 2. 从dataSArr 中找到每一列(即每一个signal)的最大值、最小值
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');

[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
% 有了 max min数值后， dataStruct 还需再次运行，以获得scaling后的数据
% 运行 dataStruct 太慢，没必要。可直接使用 dataS,dataSArr 和
% signalsMaxMinStruct，进行scaling数据的计算

[dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
% 由于数据有更新，再次 load
plotscaling = 1;
range_id = [1:5];
range_signal = [1:5];

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

