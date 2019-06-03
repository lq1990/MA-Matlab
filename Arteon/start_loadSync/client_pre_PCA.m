clear;
% close all;
clc;

% ע��matDataPcAll��norm�� (data-mean)/std
% matDataPcAll ��mean��std�� all data�ģ�ע�����ֲ���trainData�ġ�
% PC �Ѿ���ȷ������

%% PCA of all matData
load signalTable
load dataStructArrAll
matDataAll = SceSigDataTrans.structArrAll2matData(dataStructArrAll, signalTable); 
% matDataAll Ϊԭʼ���ݣ�û��norm

[ev, lambda, data_mean, data_std] = MyFeatureEng.PCA_Show(matDataAll, 'Arteon and Geely');

%% PCA::plot eigenvalue and cumsum
eigenvalue = sort(diag(lambda), 'descend');

cumsum_eigval = cumsum(eigenvalue);
figure;
subplot(211)
plot(eigenvalue, 'o', 'LineWidth', 2); 
grid on;
title('eigenvalue');

subplot(212)
plot(cumsum_eigval / max(cumsum_eigval), 'o', 'LineWidth',2);
grid on;
title('norm: cumsum of eigenvalue');
ylim([0, 1]);
ylabel('%');

% ���ۣ���ֻѡ PC1 PC2 �����Դ������塣
% ��Ϊ�˿��ӻ����壬�󷽱㣬ѡ��ǰ����PC��

%% matDataPc norm, add matDataPcAll
ev_pc = ev(:, [end:-1:1]); % ��ȷ��˳��
% �����г�����matData���н�ά��2ά
load listStructAll
for i = 1:length(listStructAll)
    itemMatData = listStructAll(i).matData;
    
    % norm��ʹ�õ�mean��std�����г���matData��������õ�
    data_mean_rep = repmat(data_mean , length(itemMatData) , 1);
    data_std_rep = repmat(data_std , length(itemMatData) , 1);
    itemMatData = (itemMatData - data_mean_rep) ./ (data_std_rep + 1e-8);
    
    itemMatDataPcAll = itemMatData * ev_pc; % (m, 17)(17,2) = (m,2)
    % create a new field matDataPc in listStructAll
    listStructAll(i).matDataPcAll = itemMatDataPcAll;
end

save '.\DataFinalSave\listStructAll' listStructAll

%% 2D. use matDataPc and score to plot
load listStructTrain

range_id = [1:10]; % total
pcs = [1:2];
amp = 5;
MyPlot.plotMatDataPcEachSce( listStructTrain, range_id, pcs, amp, {'-','-'} );


%% 3D plot, pc1-pc2-time
close all;
load listStructAll

range_id = [1:3, 30:32]; % total 36
pcs = [1:4]; % 12, 34, 56, 78
amp = 7;
MyPlot.plot3DMatDataPcTime( listStructAll, range_id, pcs, amp )


