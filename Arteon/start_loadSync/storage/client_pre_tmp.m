

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