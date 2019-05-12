% use rnn-parameters which trained in C++ to predict new data of Geely
clear; close all; clc;
addpath(genpath(pwd));

%% txt 2 dataStruct
% 注意Geely采样频率的不同 于Arteon, 在 tryASignalAllData 中修改

scenarioFile = 'scenariosOfSyncGeely.txt';
signalFile = 'signalsOfSyncGeely.txt';
sampling_factor = 100;
car_type = 'Geely';
[dataS_Geely, dataSArr_Geely, scenarioTable_Geely, signalTable_Geely] = srcDataTrans(scenarioFile, signalFile, sampling_factor, car_type);

save '.\test\scenarioTable_Geely' scenarioTable_Geely
save '.\test\signalTable_Geely' signalTable_Geely
save '.\DataFinalSave\dataS_Geely' dataS_Geely
save '.\DataFinalSave\dataSArr_Geely' dataSArr_Geely

%% scaling, use min-max val of training data
load('signalsMaxMinStruct.mat');
load('signalTable_Geely');
load dataSArr_Geely

[dataSScaling_Geely, dataSArrScaling_Geely] = MyNormalization.minMaxScaling(dataSArr_Geely, signalsMaxMinStruct, signalTable_Geely);
save '.\DataFinalSave\dataSScaling_Geely' dataSScaling_Geely
save '.\DataFinalSave\dataSArrScaling_Geely' dataSArrScaling_Geely

%% dataStruct 2 list_data_Geely
load('dataSArrScaling_Geely.mat');
load('signalTable_Geely.mat');

dataSArr = dataSArrScaling_Geely;
signalTable = signalTable_Geely;
list_data_Geely = SceSigDataTrans.allSce2ListStruct(dataSArr, signalTable); % [struct{id, score, matData}, struct, ...]

%% ====== list 中 currentGear (11. col) 太大，因为Arteon起步数据中 此项为0. =====
% 需要修正
for r = 1 : length(list_data_Geely)
    curGear = list_data_Geely(r).matData(:, 11);
    list_data_Geely(r).matData(:, 11) = zeros(length(curGear) ,1); % currentGear = 0
end

save '.\DataFinalSave\list_data_Geely' list_data_Geely

clearvars dataSArr dataSArrScaling_Geely signalTable signalTable_Geely r curGear

%% use matData and parameters to predict score
addpath(genpath(pwd));
rmpath([pwd, '\ModelParamsFromC++\DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
% rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);

% 写个 fn，对单个场景进行 前传，计算score。使用到W b
load list_data_Geely
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

list_data = list_data_Geely;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );


%% plot Geely
plotscaling = 0 ;
range_id = [ 11:17 ]; % total_id: 17
range_signal = [ 5 ]; % total_signal: 17

amp = 7; % for plot
if plotscaling==1
    load('.\DataFinalSave\dataSArrScaling_Geely.mat');
    load('.\test\signalTable_Geely.mat');
    mp = MyPlot(dataSArrScaling_Geely, signalTable_Geely, range_id , range_signal, amp ); 
    mp.show();
else
    load('.\DataFinalSave\dataSArr_Geely.mat');
    load('signalTable_Geely.mat');
    mp = MyPlot(dataSArr_Geely, signalTable_Geely, range_id , range_signal, amp); 
    mp.show();
end

clearvars mp plotscaling range_id range_signal sampling_factor;
