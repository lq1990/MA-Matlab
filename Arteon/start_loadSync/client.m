% ���ڲ���Ƶ��
% ԭʼ�� 100hz���²�������10hz���²���������ֱ��ÿ��һС��ȡһ����ֵ��
% ��ͬ����Ƶ�ʣ�Ӧ΢�� idx_t_begin idx_t_end ��ȷ�� ��������ʱFP��0 ����������Ҳ��0.

clc; close all; clear;
addpath(genpath(pwd));

%% 1. ������ dataStruct.m���� mat -> table , Arr
% ���ݱ����ˣ��²��������ճ���ʱ����clip
dataStruct(); 
% �� save dataS, dataSArr��

%% 2. ��dataSArr ���ҵ�ÿһ��(��ÿһ��signal)�����ֵ����Сֵ
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
% �洢��Ϊ��testʱҲҪ�õ�
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
plotscaling = 1 ;
range_id = [10:15];
range_signal = [5];

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
