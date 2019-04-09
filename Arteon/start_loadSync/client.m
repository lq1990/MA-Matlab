clc; close all; clear;

addpath(genpath(pwd));

%% 1. ������ dataStruct.m���� mat -> table , Arr
% ���ݱ����ˣ��²��������ճ���ʱ����clip
[tmp_asignal_val_factor] = dataStruct0(); 
% �� save dataS, dataSArr��

%% 2. ��dataSArr ���ҵ�ÿһ��(��ÿһ��signal)�����ֵ����Сֵ
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');

[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
% ���� max min��ֵ�� dataStruct �����ٴ����У��Ի��scaling�������
% ���� dataStruct ̫����û��Ҫ����ֱ��ʹ�� dataS,dataSArr ��
% signalsMaxMinStruct������scaling���ݵļ���

[dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
% ���������и��£��ٴ� load
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

