% test self-find 10 scenarios

clear; close all; clc;

addpath(genpath(pwd));

%% 1.1 Arteon, txt 2 struct
% 数据被过滤，下采样，按照场景时间做clip
scenarioFile = 'scenariosOfSync_test.txt';
signalFile = 'signalsOfSync_test.txt';
sampling_factor = 100 ; % 上采样 100hz
car_type = 'Arteon';
[dataS_test, scenarioTable_test, signalTable_test]  = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type); 

% save
dataSArr_test = struct2array(dataS_test);
save '.\test\signalTable_test' signalTable_test
save '.\test\scenarioTable_test' scenarioTable_test
save '.\test\dataS_test' dataS_test
save '.\test\dataSArr_test' dataSArr_test

%% 1.2 Geely, txt 2 struct
% 注意Geely采样频率的不同 于Arteon, 在 tryASignalAllData 中修改
scenarioFile = 'scenariosOfSyncGeely_test.txt';
signalFile = 'signalsOfSyncGeely_test.txt';
sampling_factor = 100;
car_type = 'Geely';
[dataS_Geely_test, scenarioTable_Geely_test, signalTable_Geely_test] = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type);

% save
dataSArr_Geely_test = struct2array(dataS_Geely_test);
save '.\test\scenarioTable_Geely_test' scenarioTable_Geely_test
save '.\test\signalTable_Geely_test' signalTable_Geely_test
save '.\test\dataS_Geely_test' dataS_Geely_test
save '.\test\dataSArr_Geely_test' dataSArr_Geely_test

%% 2. concat data of Arteon and Geely
load dataS_test
load dataS_Geely_test
load scenarioTable_Geely_test
load signalTable_test

dataStructAll_test = dataS_test;

% traverse Geely
scenarioTable_test = scenarioTable_Geely_test;
for i = 1 : height(scenarioTable_test)
        % 对应dataSArr 行
        idx_scenario = i;
        fieldname_cell = scenarioTable_test.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataStructAll_test.(fieldname) = dataS_Geely_test.(fieldname);
end
dataStructArrAll_test = struct2array(dataStructAll_test);
save '.\test\dataStructArrAll_test' dataStructArrAll_test

% struct 2 listStruct [{id, score, matData},{},...]
% list比struct更方便操作。matData每一列对应于 signalTable 而非txt文件。

listStructAll_test = SceSigDataTrans.allSce2ListStruct(dataStructArrAll_test, signalTable_test);
save '.\test\listStructAll_test' listStructAll_test

clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

%% zscore
load mean_train
load std_train

listStructAll_test = MyListStruct.addMatDataZScore( listStructAll_test, mean_train, std_train );
save '.\test\listStructAll_test' listStructAll_test

%% plot
load listStructAll_test
load signalTable_test

range_id = [1:10]; % 
range_signal = [1:5]; % total_signal: 17
plotZScore = 0;
amp = 1;
MyPlot.plotSignalsOfListStruct(listStructAll_test, signalTable_test, range_id, range_signal, plotZScore, {'-', '-'}, amp);

clearvars range_id range_signal plotZScore amp;

%% predict another 10 scenarios
% 场景进行 前传，计算score_class。使用到W b

% 选择参数
rmpath([pwd, '/ModelParamsFromC++/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.0073, accu 1, matDataZScore, listStructTrain']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 201, Adagrad, loss 0.03, accu 1, matDataZScore, listStructTrain, seed1']);
% rmpath([pwd, '/ModelParamsFromC++/lambda 0.19, train_cv_concat']);

Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

load listStructAll_test
list_data = listStructAll_test;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );




