% after training model in C++
% post-processing
% 1. visualization of Params and loss and accuracy
% 2. use Params to predict/test (don't forget to scale predicted data)

clear; close all; clc;

addpath(genpath(pwd));

% select params
rmpath([pwd, '/ModelParamsFromC++/DownSampling10hz, n_h 50, classes 5, alpha 0.1, epoches 501, Adagrad, loss 0.01, accu 1']);
rmpath([pwd, '/ModelParamsFromC++/Upsampling100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.126, accu 0.895']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 501, Adagrad, loss 0.0073, accu 1, matDataZScore, listStructTrain']);
rmpath([pwd, '/ModelParamsFromC++/100hz, n_h 50, classes 10, alpha 0.1, epoches 201, Adagrad, loss 0.03, accu 1, matDataZScore, listStructTrain, seed1']);
% rmpath([pwd, '/ModelParamsFromC++/lambda 0.19, train_cv_concat']);

%% Visulization of Matrix
MyPlot.showParams('Wxh', 0); % 第二个参数是 ifaxisequal
MyPlot.showParams('Whh', 1);
MyPlot.showParams('Why', 1);
MyPlot.showParams('bh', 1);
MyPlot.showParams('by', 1);

%% plot loss accu
lossall = importfile_lossall('loss_all.txt');
accuracyeachepoch = importfile_accu('accuracy_each_epoch.txt');
lossmeaneachepoch = importfile_lossmean('loss_mean_each_epoch.txt');

figure;
subplot(221)
plot(lossall); grid on;
title('loss all');

subplot(223)
plot(lossmeaneachepoch, 'LineWidth',2); grid on;
title('loss mean each epoch');

subplot(222)
plot(accuracyeachepoch, 'r','LineWidth',2); grid on;
title('accuracy each epoch');

%% re-test the trainingData and scores

% 场景进行 前传，计算score_class。使用到W b
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

maxScore = 8.9;
minScore = 6.0;
numClasses = 10 ;

load listStructTrain
list_data = listStructTrain;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

% re-test listStructCV
load listStructCV
list_data = listStructCV;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

%% test listStructTest
load listStructTest
list_data = listStructTest;
MyPredict.printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses );

%% 另外找 10 个start场景，预测
% client_post_test


%% Anim, Visulization of computing process
load listStructTrain

matData = listStructTrain(1).matDataZScore; % idx_id
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
Why = importfile_Why('Why.txt');
bh = importfile_bh('bh.txt');
by = importfile_by('by.txt');

showComputeProcessHY(matData, Wxh, Whh, Why, bh, by);


%% figure out what RNN really learnt.
% what has each neuron learnt, 
% each neuron is a detector,
% each neuron has its own scope, it only focuses on particular patterns.
% We need to know which kind of pattern does each neuron recognize.
% i.e. in which patterns, a neuron will be activated or fired.
% !!! If we know the maps (neuron : pattern)
%       we can easily understand
%       how the classification works.

% 找到每个neuron被激活的pattern
load listStructTrain
Wxh = importfile_Wxh('Wxh.txt');
Whh = importfile_Whh('Whh.txt');
bh = importfile_bh('bh.txt');
margin = 0.9; % 'max.' excite the neuron

neuronPatternS = neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin);
neuronPatternSArr = struct2array(neuronPatternS);
save '.\DataFinalSave\neuronPatternS' neuronPatternS
save '.\DataFinalSave\neuronPatternSArr' neuronPatternSArr

%% plot neuron : pattern(part of scenarios)
% 类比于：按signal，把所有场景plot。
% 此处：按照每个neuron，把场景激活时间段的 PC12 数据高亮，激活事件对应的信号即pattern
% 使用PC12，而非原始17个信号，为了可视化方便

load listStructTrain % 借助listStruct取得 id
load neuronPatternSArr
% 一个neuron对应22个场景，把场景激活区域高亮，其它区域正常

range_neurons = [ 4 ]; % 28-, 36+
range_id = [1 : 22];

[ score_min, score_max ] = MyPlot.findScoreMinMaxOfListStruct(listStructTrain, range_id);

for i = 1 : length(neuronPatternSArr)
    if ~ismember(i, range_neurons)
        continue
    end
    
    % 外层循环取得每个neuron，一个neuron一个figure
    figure;
    set(gcf, 'position', [500, -100, 1000, 800]);
    cur_neuron = neuronPatternSArr(i);
    
    legend_cell = {};
    for j = 1 : length(listStructTrain)
        if ~ismember(j, range_id)
            continue
        end
        
        % 内层循环遍历每个场景，需借助listStruct拿到 id
        item_id = listStructTrain(j).id;
        item_id_str = ['id', num2str(item_id)];
        item_details = listStructTrain(j).details;
        item_score = listStructTrain(j).score;
        item_matDataPC1 = listStructTrain(j).matDataPcAll(:, 1); % ```注意```：此处的PC1是按照 mean_all std_all 而非trainDataset，不过当train/test 同分布时，没有问题
        item_matDataPC2 = listStructTrain(j).matDataPcAll(:, 2); 
        
        cur_neuron_id = cur_neuron.(item_id_str); % 当前neuron对应的一个场景要高亮显示的index
        if isempty(cur_neuron_id)
            continue
        end
        
        subplot(121)
        % 先把matDataPC1 plot
        plot(item_matDataPC1,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * 3+0.5); 
        grid on; hold on;
        legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % 再高亮使neuron激活的部分
        plot(cur_neuron_id, item_matDataPC1(cur_neuron_id), 'ko', 'LineWidth', 1);
        legend_cell = [legend_cell, 'pattern'];
        title(['neuron ', num2str(i), ', PC1']);
        legend(legend_cell);
        
        subplot(122)
        % 先把matDataPC2 plot
        plot(item_matDataPC2,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * 5+0.5); 
        grid on; hold on;
        legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % 再高亮使neuron激活的部分
        plot(cur_neuron_id, item_matDataPC2(cur_neuron_id), 'ko', 'LineWidth', 1);
        legend_cell = [legend_cell, 'pattern'];
        title(['neuron ', num2str(i), ', PC2']);
        legend(legend_cell);    
        
    end
    
    
    
end




