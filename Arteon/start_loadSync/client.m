clc; close all; 

addpath(genpath(pwd));

%% 先运行 dataStruct.m，从txt源文件 -> table , Arr
% dataStruct

%% plot
load('.\DataFinalSave\dataSArr.mat');
load('.\src\kpTable.mat');

mp = MyPlot(dataSArr, kpTable, [1:10] , [1:5, 13, 36] ); % 3. range_id, 4. range_kp
mp.show();
