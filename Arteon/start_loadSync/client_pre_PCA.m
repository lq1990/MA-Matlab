clear;
% close all;
clc;

% 注：matDataPc是norm的

%% PCA of all matData
load signalTable
load dataStructArrAll
matDataAll = SceSigDataTrans.structArrAll2matData(dataStructArrAll, signalTable); 
% matDataAll 为原始数据，没有norm

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

% 结论：若只选 PC1 PC2 不足以代表整体。
% 但为了可视化整体，求方便，选用前两个PC。

%% get pc1, pc2, then plot them over time 此处对matDataPc norm
ev_pc12 = ev(:, [end, end-1]); % (17,2)
% 对所有场景的matData进行降维到2维
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



