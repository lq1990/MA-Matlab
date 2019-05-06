% ���ڲ���Ƶ��
% ԭʼ�� 100hz���²�������10hz���²���������ֱ��ÿ��һС��ȡһ����ֵ��
% ��ͬ����Ƶ�ʣ�t_end��ͬ��Ӧ΢�� idx_t_begin t_end ��ȷ�� ��������ʱFP��0 ����������Ҳ��0.
% �ϲ���ʱ��һ��Ҫע�⣺sync_t ��extend���������ظ�ǰһ��t��

clc; close all; clear;

addpath(genpath(pwd));

%% 1. ������ dataStruct.m���� mat -> table , Arr
% ���ݱ����ˣ��²��������ճ���ʱ����clip
sampling_factor = 100 ; % �ϲ��� 100hz
dataStruct(sampling_factor); 

% �� save dataS, dataSArr��

%% 2. ��dataSArr ���ҵ�ÿһ��(��ÿһ��signal)�����ֵ����Сֵ
load('.\DataFinalSave\dataSArr.mat');
load('.\src\signalTable.mat');
[signalsMaxMinStruct] = findSignalsMaxMin(dataSArr, signalTable);
% �洢��Ϊ��testʱҲҪ�õ�
save '.\DataFinalSave\signalsMaxMinStruct' signalsMaxMinStruct

%% 3. scaling
[dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable );
save '.\DataFinalSave\dataSScaling' dataSScaling
save '.\DataFinalSave\dataSArrScaling' dataSArrScaling

%% 4. plot
plotscaling = 1;
range_id = [1:19]; % total_id: 19
range_signal = [1:5]; % total_signal: 17

if plotscaling==1
    load('.\DataFinalSave\dataSArrScaling.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArrScaling, signalTable, range_id , range_signal ); 
    mp.show();
else
    load('.\DataFinalSave\dataSArr.mat');
    load('.\src\signalTable.mat');
    mp = MyPlot(dataSArr, signalTable, range_id , range_signal  ); 
    mp.show();
end

clearvars mp plotscaling range_id range_signal sampling_factor;


%% Correlation Coefficient , PCA
% �����г����������źŵ�ʱ������ �ŵ�һ��matrix��
load('dataSArr');
load('signalTable.mat');

allMatData = zeros(1, length(signalTable.signalName));

for i = 1:length(dataSArr) % ����ÿ������
     aMatData= [];
     for j = 1: height(signalTable) % ����ÿ��signal
         signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
         
         a_scenario_signal_data = dataSArr(i).(signalName);
         aMatData(:, j) = a_scenario_signal_data;
     end
     allMatData = vertcat(allMatData, aMatData);
end
allMatData = allMatData(2:end, :); % �ѵ�һ��ȥ��
clearvars i j aMatData signalName_cell signalName a_scenario_signal_data;

% ========== normalization, (data-mean) ./ std, let mean=0 & var=1 ======================
data_mean = repmat(mean(allMatData), length(allMatData),1 );
data_std = repmat(std(allMatData), length(allMatData),1 );

allMatData = (allMatData - data_mean) ./ (data_std+1e-8); % avoid num/0

% covariance, over cols
var_data = var(allMatData);
cov_data = cov(allMatData); % equivalent to Correlation Coefficient because of normaliation

% figure;
% showMatrix('var', var_data, 0);
figure;
showMatrix('cov', cov_data, 0);

% ================= PCA ===============================
[ev, lambda] = eig(cov_data);

figure;
showMatrix('lambda', lambda, 0);

figure;
showMatrix('eigenvector', ev, 0);

