clc; close all;

addpath(genpath(pwd));

%% ������ dataStruct.m����txtԴ�ļ� -> table , Arr
% dataStruct

%% plot

mp = MyPlot(dataSArr, kpTable, 1:13 , 1:10 ); % 3. range_id, 4. range_kp
mp.show();
