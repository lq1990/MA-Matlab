clear; 
% close all; 
clc;

%% Correlation Coefficient , PCA
% �����г����������źŵ�ʱ������ �ŵ�һ��matrix��

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

MyFeatureEng.PCA_Show(allMatData, carStr);
