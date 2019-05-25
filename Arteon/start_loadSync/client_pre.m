% run files in sequence:
% client_pre -> client_core -> client_post

% author: Qiang Liu
% from Apr, 2019

%%
% 关于采样频率
% 原始是 100hz，下采样后是10hz。下采样方法：直接每隔一小段取一个数值。
% 不同采样频率，t_end不同。应微调 idx_t_begin t_end 以确保 汽车启动时FP是0 且启动结束也是0.
% 上采样时，一定要注意：sync_t 的extend，不能是重复前一个t。

% 编号
% Arteon: id 10xxx
% Geely  : id 20xxx

% 注意： matDataPcAll是由listStruct得到的，matDataPcAll不能单独在train中用。

clc; close all; clear;

addpath(genpath(pwd));

%% 1.1 Arteon, txt 2 struct
% 数据被过滤，下采样，按照场景时间做clip
scenarioFile = 'scenariosOfSync.txt';
signalFile = 'signalsOfSync.txt';
sampling_factor = 100 ; % 上采样 100hz
car_type = 'Arteon';
[dataS, scenarioTable, signalTable]  = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr = struct2array(dataS);
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable
save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

%% 1.2 Geely, txt 2 struct
% 注意Geely采样频率的不同 于Arteon, 在 tryASignalAllData 中修改
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
        % 对应dataSArr 行
        idx_scenario = i;
        fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataStructAll.(fieldname) = dataS_Geely.(fieldname);
end
dataStructArrAll = struct2array(dataStructAll);
save '.\DataFinalSave\dataStructArrAll' dataStructArrAll
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

% struct 2 listStruct [{id, score, matData},{},...]
% list比struct更方便操作。matData每一列对应于 signalTable 而非txt文件。

listStructAll = SceSigDataTrans.allSce2ListStruct(dataStructArrAll, signalTable);
save '.\DataFinalSave\listStructAll' listStructAll

%% 3. train/test dataset split, listStructAll split
load listStructAll
listStructAll_shuffle = MyUtil.shuffleListStruct(listStructAll, 1); % rand('seed', seed); 打乱顺序

% 36/4*3 = 27 #Train
listStructTrain = listStructAll_shuffle(1 : 27);
listStructTest = listStructAll_shuffle(28 : 36);

% norm Train-dataset, using Z-score Standardization
matDataTrainAll = MyListStruct.listStruct2OneMatData(listStructTrain);
mean_train = mean(matDataTrainAll); std_train = std(matDataTrainAll);

listStructTrain = MyListStruct.addMatDataZScore( listStructTrain, mean_train, std_train );
listStructTest = MyListStruct.addMatDataZScore( listStructTest, mean_train, std_train ); % test dataset 也是按照 mean_train std_train 来norm

save '.\DataFinalSave\listStructTrain' listStructTrain
save '.\DataFinalSave\listStructTest' listStructTest
save '.\DataFinalSave\mean_train' mean_train % 保存之后的train-mean和train-std，在以后的test数据的norm中用到。
save '.\DataFinalSave\std_train' std_train

%% 使用 listStructTrain.matDataZScore 对RNN训练


% 有了RNN的模型参数后，predict listStructTest.matDataZScore
% 另找10个起步场景，做预测

% post阶段，可视化 采样数据-模型-分类 过程

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

