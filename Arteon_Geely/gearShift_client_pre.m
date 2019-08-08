%% scenarios: gearShift

% run files in sequence:
% client_pre -> client_core -> client_post

% author: Qiang Liu
% begin: Apr, 2019

%%
% ���
% Arteon: id 10xxx
% Geely  : id 20xxx

% ע�⣺ matDataPcAll����listStruct�õ��ģ�matDataPcAll���ܵ�����train���á�

clc; close all; clear;

addpath(genpath(pwd));
rmpath(genpath(strcat(pwd, '\script\')));

%% 1.1 Arteon, txt 2 struct
% ���ݱ����ˣ��²��������ճ���ʱ����clip
scenarioFile = 'scenariosOfSync_gearS.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % �ϲ��� 100hz
car_type = 'Arteon';
[dataS, scenarioTable, signalTable]  = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr = struct2array(dataS);
save '.\common\src\signalTable' signalTable
save '.\gearShift_loadSync\src\scenarioTable' scenarioTable
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS' dataS
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataSArr' dataSArr

%% 1.2 Geely, txt 2 struct
% ע��Geely����Ƶ�ʵĲ�ͬ ��Arteon, �� tryASignalAllData ���޸�
scenarioFile = 'scenariosOfSyncGeely_gearS.txt';
signalFile = 'signalsOfSyncGeely.txt';
sampling_factor = 100;
car_type = 'Geely';
[dataS_Geely, scenarioTable_Geely, signalTable_Geely] = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type);

% save
dataSArr_Geely = struct2array(dataS_Geely);
save '.\common\src\signalTable_Geely' signalTable_Geely
save '.\gearShift_loadSync\src\scenarioTable_Geely' scenarioTable_Geely
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS_Geely' dataS_Geely
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataSArr_Geely' dataSArr_Geely

%% 2. concat data of Arteon and Geely
load('.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS.mat');
load('.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS_Geely.mat');
load('.\gearShift_loadSync\src\scenarioTable_Geely');
load '.\common\src\signalTable.mat'

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
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataStructArrAll' dataStructArrAll
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

% struct 2 listStruct [{id, score, matData},{},...]
% list��struct�����������matDataÿһ�ж�Ӧ�� signalTable ����txt�ļ���

listStructAll = SceSigDataTrans.allSce2ListStruct(dataStructArrAll, signalTable);
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll' listStructAll

%% 3. train/CV/test dataset split, listStructAll split. 0.6/0.2/0.2
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll'
listStructAll_shuffle = MyUtil.shuffleListStruct(listStructAll, 1); % rand('seed', seed); ����˳��

len = length(listStructAll);
% 6/2/2
listStructTrain = listStructAll_shuffle(1 : floor(len * 0.6));
listStructCV = listStructAll_shuffle(floor(len * 0.6) + 1 : floor(len * 0.8));
listStructTest = listStructAll_shuffle(floor(len * 0.8) + 1 : len);

% norm Train-dataset, using Z-score Standardization
matDataTrainAll = MyListStruct.listStruct2OneMatData(listStructTrain);
mean_train = mean(matDataTrainAll); std_train = std(matDataTrainAll);

listStructTrain = MyListStruct.addMatDataZScore( listStructTrain, mean_train, std_train );
listStructCV = MyListStruct.addMatDataZScore( listStructCV, mean_train, std_train );
listStructTest = MyListStruct.addMatDataZScore( listStructTest, mean_train, std_train ); % CV/test dataset Ҳ�ǰ��� mean_train std_train ��norm

save '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain' listStructTrain
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructCV' listStructCV
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructTest' listStructTest
save '.\gearShift_loadSync\DataFinalSave\list_data\mean_train' mean_train % ����֮���train-mean��train-std�����Ժ��test���ݵ�norm���õ���
save '.\gearShift_loadSync\DataFinalSave\list_data\std_train' std_train

%% ʹ�� listStructTrain.matDataZScore ��RNNѵ��


% ����RNN��ģ�Ͳ�����predict listStructTest.matDataZScore
% ����10���𲽳�������Ԥ��

% post�׶Σ����ӻ� ��������-ģ��-���� ����

%%  plot data of Arteon and Geely
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\common\src\signalTable'

listStruct = listStructTrain;
len = length(listStruct);

range_id = [1 : len/10]; % 
range_signal = [1:17]; % total_signal: 17
plotZScore = 1;
amp = 10;
MyPlot.plotSignalsOfListStruct(listStruct, signalTable, range_id, range_signal, plotZScore, {'-', '-'}, amp);

clearvars range_id range_signal plotZScore amp;

%% hist
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructCV'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTest'

len = length(listStructAll);

left = 4.9;
interval = 0.3;
right = 9.1;
classes = (right-left)/interval; % 14 classes

edges = left : interval : right;
xlimit = [left,right];
titleStr = strcat('Arteon and Geely, total len: ', num2str(len), ', classes: ', num2str(classes));
MyPlot.plotHistogram(listStructAll, edges, xlimit, titleStr);

set(gca,'XTick', left : interval : right);


MyPlot.plotHistogram(listStructTrain, edges, xlimit, 'Train dataset');
% MyPlot.plotHistogram(listStructCV, edges, xlimit, 'CV dataset');
% MyPlot.plotHistogram(listStructTest, edges, xlimit, 'Test dataset');

clearvars len  left interval right classes edges xlimit titleStr;
