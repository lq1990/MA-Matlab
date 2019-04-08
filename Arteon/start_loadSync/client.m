clc; close all; clear;

addpath(genpath(pwd));

%% 1. ������ dataStruct.m���� mat -> table , Arr
% ���ݱ����ˣ��²��������ճ���ʱ����clip
dataStruct(); 
% ��write dataS, dataSArr��

%% 2. ��dataSArr ���ҵ�ÿһ��(��ÿһ��signal)�����ֵ����Сֵ
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');

[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
% ���� max min��ֵ�� dataStruct �����ٴ����У��Ի��scaling�������
dataStruct(signalsMaxMinStruct); 

%% 4. plot
% ���������и��£��ٴ� load
load('.\DataFinalSave\dataSArrScaling.mat');
load('.\src\signalTable.mat');

mp = MyPlot(dataSArrScaling, signalTable, [1 : 20] , [12:16] ); % #3. range_id, #4. range_signal
mp.show();
