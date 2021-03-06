%% scenarios: gearShift

% run files in sequence:
% client_pre -> client_core -> client_post

% author: Qiang Liu
% begin: Apr, 2019

%%
% 编号
% Arteon: id 10xxx
% Geely  : id 20xxx

% 注意： matDataPcAll是由listStruct得到的，matDataPcAll不能单独在train中用。

clc; close all; clear;

addpath(genpath(pwd));
rmpath(genpath(strcat(pwd, '\script\')));
rmpath(genpath(strcat(pwd, '\gearShiftUp_loadSync\')));
rmpath(genpath(strcat(pwd, '\gearShiftDown_loadSync\')));
rmpath(genpath(strcat(pwd, '\gearShift_loadSync - Copy\')));

%% 1.1 Arteon, txt 2 struct
% 数据被过滤，下采样，按照场景时间做clip
scenarioFile = 'scenariosOfSync_gearS.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % 上采样 100hz
car_type = 'Arteon';
[dataS, scenarioTable, signalTable]  = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr = struct2array(dataS);
save '.\common\src\signalTable' signalTable
save '.\gearShift_loadSync\src\scenarioTable' scenarioTable
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS' dataS
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataSArr' dataSArr

%% 1.2 Geely, txt 2 struct
% 注意Geely采样频率的不同 于Arteon, 在 tryASignalAllData 中修改
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
load('.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataSArr.mat');
load('.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataS_Geely.mat');
load('.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataSArr_Geely.mat');
load('.\gearShift_loadSync\src\scenarioTable_Geely');
load '.\common\src\signalTable.mat'

dataStructAll = dataS;

% traverse Geely
scenarioTable = scenarioTable_Geely;
for i = 1 : height(scenarioTable)
        % 对应dataSArr 行
        idx_scenario = i;
        fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataStructAll.(fieldname) = dataS_Geely.(fieldname);
end

dataStructArrAll = struct2array(dataStructAll);
save '.\gearShift_loadSync\DataFinalSave\dataS_SArr\dataStructArrAll' dataStructArrAll
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

% struct 2 listStruct [{id, score, matData},{},...]
% list比struct更方便操作。matData每一列对应于 signalTable 而非txt文件。

listStructArteon = SceSigDataTrans.allSce2ListStruct(dataSArr, signalTable);
listStructGeely = SceSigDataTrans.allSce2ListStruct(dataSArr_Geely, signalTable);
listStructAll = SceSigDataTrans.allSce2ListStruct(dataStructArrAll, signalTable);
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll' listStructAll
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructArteon' listStructArteon
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructGeely' listStructGeely

%% 3. train/CV/test dataset split, listStructAll split. 0.6/0.2/0.2
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll'
listStructAll_shuffle = MyUtil.shuffleListStruct(listStructAll, 6); % rand('seed', seed); 打乱顺序

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
listStructTest = MyListStruct.addMatDataZScore( listStructTest, mean_train, std_train ); % CV/test dataset 也是按照 mean_train std_train 来norm

save '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain' listStructTrain
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructCV' listStructCV
save '.\gearShift_loadSync\DataFinalSave\list_data\listStructTest' listStructTest
save '.\gearShift_loadSync\DataFinalSave\list_data\mean_train' mean_train % 保存之后的train-mean和train-std，在以后的test数据的norm中用到。
save '.\gearShift_loadSync\DataFinalSave\list_data\std_train' std_train

%% 使用 listStructTrain.matDataZScore 对RNN训练


% 有了RNN的模型参数后，predict listStructTest.matDataZScore
% 另找10个起步场景，做预测

% post阶段，可视化 采样数据-模型-分类 过程

%%  plot data of Arteon and Geely
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\common\src\signalTable'

listStruct = listStructTrain;
len = length(listStruct);

range_id = [ floor(len/10 * 7.5) : len/10 * 8]; % 
% range_id = [1];
range_signal = [1:21]; % total_signal: 21
plotZScore = 1;
amp = 10;
MyPlot.plotSignalsOfListStruct(listStruct, signalTable, range_id, range_signal, plotZScore, {'-', '-'}, amp);

clearvars range_id range_signal plotZScore amp;

%% hist
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructAll'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTrain'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructCV'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructTest'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructArteon'
load '.\gearShift_loadSync\DataFinalSave\list_data\listStructGeely'

minScore = 4;
maxScore = 10;
inter = 1.2;

MyPlot.plotHist( listStructAll, minScore, inter, maxScore, 'Arteon and Geely');
ylim([0, 40]);

% MyPlot.plotHist( listStructArteon, minScore, inter, maxScore, 'Arteon'); ylim([0, 40]);
% MyPlot.plotHist( listStructGeely, minScore, inter, maxScore, 'Geely'); ylim([0, 40]);

% training/validation/test dataset
MyPlot.plotHist( listStructTrain, minScore, inter, maxScore, 'Training dataset hist');
MyPlot.plotHist( listStructCV, minScore, inter, maxScore, 'Validation dataset hist');
MyPlot.plotHist( listStructTest, minScore, inter, maxScore, 'Test dataset hist');

