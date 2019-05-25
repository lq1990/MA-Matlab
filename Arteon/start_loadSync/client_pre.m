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

% ע�⣺ matDataPcAll����listStruct�õ��ģ�matDataPcAll���ܵ�����train���á�

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

%% 3. train/test dataset split, listStructAll split
load listStructAll
listStructAll_shuffle = MyUtil.shuffleListStruct(listStructAll, 1); % rand('seed', seed); ����˳��

% 36/4*3 = 27 #Train
listStructTrain = listStructAll_shuffle(1 : 27);
listStructTest = listStructAll_shuffle(28 : 36);

% norm Train-dataset, using Z-score Standardization
matDataTrainAll = MyListStruct.listStruct2OneMatData(listStructTrain);
mean_train = mean(matDataTrainAll); std_train = std(matDataTrainAll);

listStructTrain = MyListStruct.addMatDataZScore( listStructTrain, mean_train, std_train );
listStructTest = MyListStruct.addMatDataZScore( listStructTest, mean_train, std_train ); % test dataset Ҳ�ǰ��� mean_train std_train ��norm

save '.\DataFinalSave\listStructTrain' listStructTrain
save '.\DataFinalSave\listStructTest' listStructTest
save '.\DataFinalSave\mean_train' mean_train % ����֮���train-mean��train-std�����Ժ��test���ݵ�norm���õ���
save '.\DataFinalSave\std_train' std_train

%% ʹ�� listStructTrain.matDataZScore ��RNNѵ��


% ����RNN��ģ�Ͳ�����predict listStructTest.matDataZScore
% ����10���𲽳�������Ԥ��

% post�׶Σ����ӻ� ��������-ģ��-���� ����

%%  plot data of Arteon and Geely
load listStructTest
load signalTable
range_id = [4:8]; % 
range_signal = [10:17]; % total_signal: 17
plotZScore = 1;
amp = 10;
MyPlot.plotSignalsOfListStruct(listStructTest, signalTable, range_id, range_signal, plotZScore, {'-', '-'}, amp);

clearvars range_id range_signal plotZScore amp;

%% hist
edges = [6:0.3:9.0];
xlimit = [5,10];
titleStr = 'Arteon and Geely';
MyPlot.plotHistogram(listStructAll, edges, xlimit, titleStr);

MyPlot.plotHistogram(listStructTrain, [6:0.3:9.0], [5,10], 'Train dataset');
MyPlot.plotHistogram(listStructTest, [6:0.3:9.0], [5,10], 'Test dataset');

