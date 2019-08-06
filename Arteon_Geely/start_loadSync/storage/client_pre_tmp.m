

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