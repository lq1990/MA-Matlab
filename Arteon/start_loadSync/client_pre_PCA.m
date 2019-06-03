clear;
% close all;
clc;

% 注：matDataPcAll是norm的 (data-mean)/std
% matDataPcAll 的mean和std是 all data的，注意区分不是trainData的。
% PC 已经正确排序了

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

%% matDataPc norm, add matDataPcAll
ev_pc = ev(:, [end:-1:1]); % 正确的顺序
% 对所有场景的matData进行降维到2维
load listStructAll
for i = 1:length(listStructAll)
    itemMatData = listStructAll(i).matData;
    
    % norm，使用的mean和std是所有场景matData的数据求得的
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


