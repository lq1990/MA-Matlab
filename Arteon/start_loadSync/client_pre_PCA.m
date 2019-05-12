clear; 
% close all; 
clc;

%% Correlation Coefficient , PCA
% 将所有场景中所有信号的时序数据 放到一个matrix中

car = 2 ; % 1: Arteon, 2: Geely

if car == 1
    carStr = 'Arteon';
    load('dataSArr');
    load('signalTable.mat');
else
    carStr = 'Geely';
    load('dataSArr_Geely');
    load('signalTable_Geely.mat');
    dataSArr = dataSArr_Geely;
    signalTable = signalTable_Geely;
end

allMatData = SceSigDataTrans.structArrAll2matData(dataSArr, signalTable);

clearvars i j aMatData signalName_cell signalName a_scenario_signal_data;

%% ========== normalization, (data-mean) ./ std, let mean=0 & var=1 ======================
data_mean = repmat(mean(allMatData), length(allMatData),1 );
data_std = repmat(std(allMatData), length(allMatData),1 );

allMatData = (allMatData - data_mean) ./ (data_std+1e-8); % avoid num/0

% covariance, over cols
var_data = var(allMatData);
cov_data = cov(allMatData); % equivalent to Correlation Coefficient because of normaliation

% figure;
% showMatrix('var', var_data, 0);
figure;
MyPlot.showMatrix('cov', cov_data, 0, carStr);

%% ================= PCA ===============================
[ev, lambda] = eig(cov_data); % ev是正交矩阵, ev*ev'=E。 ev 每列都是单位向量，且两两之间正交

figure;
MyPlot.showMatrix('lambda', lambda, 0, carStr);

figure;
MyPlot.showMatrix('eigenvector', ev, 0, carStr);
