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
clearvars fieldname fieldname_cell i idx_scenario dataS dataS_Geely scenarioTable scenarioTable_Geely

%  plot data of Arteon and Geely
% range_id = [1:5, 21:23]; % total 36
% range_signal = [1:7]; % total_signal: 17
% amp = 10;
% mp = MyPlot(dataStructArrAll, signalTable, range_id , range_signal, amp ); 
% mp.show();

%% train/test dataset split


%% 2. 从dataSArr 中找到每一列(即每一个signal)的最大值、最小值
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = MyFeatureEng.findSignalsMaxMin(dataSArr, signalTable);
% 存储，为了test时也要用到
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]= MyFeatureEng.minMaxScaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling



%% 4. plot
plotscaling = 0;
range_id = [1:5]; % total_id: 19
range_signal = [11:13]; % total_signal: 17

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

%% PCA
