clear;
% close all;
clc;

% ע��matDataPc��norm��

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

%% get pc1, pc2, then plot them over time �˴���matDataPc norm
ev_pc12 = ev(:, [end, end-1]); % (17,2)
% �����г�����matData���н�ά��2ά
load listStructAll
for i = 1:length(listStructAll)
    itemMatData = listStructAll(i).matData;
    
    % norm
    data_mean_rep = repmat(data_mean , length(itemMatData) , 1);
    data_std_rep = repmat(data_std , length(itemMatData) , 1);
    itemMatData = (itemMatData - data_mean_rep) ./ (data_std_rep + 1e-8);
    
    itemMatDataPc = itemMatData * ev_pc12; % (m, 17)(17,2) = (m,2)
    % create a new field matDataPc in listStructAll
    listStructAll(i).matDataPc = itemMatDataPc;
end


%% 2D. use matDataPc and score to plot
range_id = [1:5, 20:25]; % total 36
amp = 5;
plotMatData( listStructAll,  [1,2], {'PC1', 'PC2'}, range_id, amp );



%% 3D plot, pc1-pc2-time
range_id = [1:5, 20:25]; % total 36
amp = 5;
plot3DMatDataPcTime(listStructAll, range_id, amp);



