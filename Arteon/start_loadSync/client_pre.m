% run files in sequence:
% client_pre -> client_core -> client_post

% author: Qiang Liu
% from Apr, 2019

%%
% ���ڲ���Ƶ��
% ԭʼ�� 100hz���²�������10hz���²���������ֱ��ÿ��һС��ȡһ����ֵ��
% ��ͬ����Ƶ�ʣ�t_end��ͬ��Ӧ΢�� idx_t_begin t_end ��ȷ�� ��������ʱFP��0 ����������Ҳ��0.
% �ϲ���ʱ��һ��Ҫע�⣺sync_t ��extend���������ظ�ǰһ��t��

% ���
% Arteon: id 10xxx
% Geely  : id 20xxx

clc; close all; clear;

addpath(genpath(pwd));

%% 1.1 Arteon, txt 2 struct
% ���ݱ����ˣ��²��������ճ���ʱ����clip
scenarioFile = 'scenariosOfSync.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % �ϲ��� 100hz
car_type = 'Arteon';
[dataS, scenarioTable, signalTable]  = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr = struct2array(dataS);
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable
save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

%% 1.2 Geely, txt 2 struct
% ע��Geely����Ƶ�ʵĲ�ͬ ��Arteon, �� tryASignalAllData ���޸�
scenarioFile = 'scenariosOfSyncGeely.txt';
signalFile = 'signalsOfSyncGeely.txt';
sampling_factor = 100;
car_type = 'Geely';
[dataS_Geely, scenarioTable_Geely, signalTable_Geely] = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type);

% save
dataSArr_Geely = struct2array(dataS_Geely);
save '.\test\scenarioTable_Geely' scenarioTable_Geely
save '.\test\signalTable_Geely' signalTable_Geely
save '.\DataFinalSave\dataS_Geely' dataS_Geely
save '.\DataFinalSave\dataSArr_Geely' dataSArr_Geely

%% 2. concat data of Arteon and Geely
load dataS
load dataS_Geely
load scenarioTable_Geely
load signalTable

dataStructAll = dataS;

% traverse Geely
scenarioTable = scenarioTable_Geely;
for i = 1 : height(scenarioTable)
        % ��ӦdataSArr ��
        idx_scenario = i;
        fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataStructAll.(fieldname) = dataS_Geely.(fieldname);
end
dataStructArrAll = struct2array(dataStructAll);
save '.\DataFinalSave\dataStructArrAll' dataStructArrAll
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

% struct 2 listStruct [{id, score, matData},{},...]
% list��struct�����������matDataÿһ�ж�Ӧ�� signalTable ����txt�ļ���

listStructAll = SceSigDataTrans.allSce2ListStruct(dataStructArrAll, signalTable);
save '.\DataFinalSave\listStructAll' listStructAll

%% hist
load listStructAll
score_list = [];
for i = 1 : length(listStructAll)
    item = listStructAll(i);
    score_list = [score_list; item.score];
end
figure;
edges = [6:0.3:9.0];
histogram(score_list, edges);
grid on;
xlim([5,10]);
title('Arteon and Geely');

%% train/test dataset split

%% scale train-dataset


%% 2. ��dataSArr ���ҵ�ÿһ��(��ÿһ��signal)�����ֵ����Сֵ
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = MyFeatureEng.findSignalsMaxMin(dataSArr, signalTable);
% �洢��Ϊ��testʱҲҪ�õ�
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]= MyFeatureEng.minMaxScaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling



%% 4. plot Arteon
plotscaling = 0;
range_id = [1:19]; % total_id: 19
range_signal = [ 17 ]; % total_signal: 17

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

%%  plot data of Arteon and Geely
range_id = [1:36]; % total 36
range_signal = [1:17]; % total_signal: 17
amp = 10;
mp = MyPlot(dataStructArrAll, signalTable, range_id , range_signal, amp ); 
mp.show();


%% PCA
