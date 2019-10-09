%% scenarios: gearShift UpShift

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
scenarioFile = 'scenariosOfSync_gearSUp.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % �ϲ��� 100hz
car_type = 'Arteon';
[dataS, scenarioTable, signalTable]  = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr = struct2array(dataS);
save '.\common\src\signalTable' signalTable
save '.\gearShiftUp_loadSync\src\scenarioTable' scenarioTable
save '.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataS' dataS
save '.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataSArr' dataSArr

%% 1.2 Geely, txt 2 struct
% ע��Geely����Ƶ�ʵĲ�ͬ ��Arteon, �� tryASignalAllData ���޸�
scenarioFile = 'scenariosOfSyncGeely_gearSUp.txt';
signalFile = 'signalsOfSyncGeely.txt';
sampling_factor = 100;
car_type = 'Geely';
[dataS_Geely, scenarioTable_Geely, signalTable_Geely] = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type);

% save
dataSArr_Geely = struct2array(dataS_Geely);
save '.\common\src\signalTable_Geely' signalTable_Geely
save '.\gearShiftUp_loadSync\src\scenarioTable_Geely' scenarioTable_Geely
save '.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataS_Geely' dataS_Geely
save '.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataSArr_Geely' dataSArr_Geely

%% 2. concat data of Arteon and Geely
load('.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataS.mat');
load('.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataSArr.mat');
load('.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataS_Geely.mat');
load('.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataSArr_Geely.mat');
load('.\gearShiftUp_loadSync\src\scenarioTable_Geely');
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
save '.\gearShiftUp_loadSync\DataFinalSave\dataS_SArr\dataStructArrAll' dataStructArrAll
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

% struct 2 listStruct [{id, score, matData},{},...]
% list��struct�����������matDataÿһ�ж�Ӧ�� signalTable ����txt�ļ���

listStructArteon = SceSigDataTrans.allSce2ListStruct(dataSArr, signalTable);
listStructGeely = SceSigDataTrans.allSce2ListStruct(dataSArr_Geely, signalTable);
listStructAll = SceSigDataTrans.allSce2ListStruct(dataStructArrAll, signalTable);
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructAll' listStructAll
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructArteon' listStructArteon
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructGeely' listStructGeely

%% 3. train/CV/test dataset split, listStructAll split. 0.6/0.2/0.2
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructAll'
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

save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructTrain' listStructTrain
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructCV' listStructCV
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructTest' listStructTest
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\mean_train' mean_train % ����֮���train-mean��train-std�����Ժ��test���ݵ�norm���õ���
save '.\gearShiftUp_loadSync\DataFinalSave\list_data\std_train' std_train

%% ʹ�� listStructTrain.matDataZScore ��RNNѵ��


% ����RNN��ģ�Ͳ�����predict listStructTest.matDataZScore
% ����10���𲽳�������Ԥ��

% post�׶Σ����ӻ� ��������-ģ��-���� ����

%%  plot data of Arteon and Geely
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\common\src\signalTable'

listStruct = listStructTrain;
len = length(listStruct);

range_id = [ floor(len/10 * 7) : len/10 * 8]; % 
% range_id = [1];
range_signal = [1:21]; % total_signal: 21
plotZScore = 1;
amp = 10;
MyPlot.plotSignalsOfListStruct(listStruct, signalTable, range_id, range_signal, plotZScore, {'-', '-'}, amp);

clearvars range_id range_signal plotZScore amp;

%% hist
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructAll'
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructCV'
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructTest'
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructArteon'
load '.\gearShiftUp_loadSync\DataFinalSave\list_data\listStructGeely'

minScore = 4.9;
maxScore = 9.4;
inter = 0.3;

MyPlot.plotHist( listStructAll, minScore, 0.3, maxScore, 'Arteon and Geely');
ylim([0, 40]);

MyPlot.plotHist( listStructArteon, minScore, 0.3, maxScore, 'Arteon'); ylim([0, 40]);
MyPlot.plotHist( listStructGeely, minScore, 0.3, maxScore, 'Geely'); ylim([0, 40]);

