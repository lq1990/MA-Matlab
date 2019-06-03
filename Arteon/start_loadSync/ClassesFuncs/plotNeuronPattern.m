function plotNeuronPattern( listStructTrain, neuronPatternSArr, range_neurons, range_id )
    % plot the part of scenarios that activate a neuron
    % this part of scenario is called pattern.
    % labels depends on  recombination of different patterns 
amp = 5;
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
        item_id_str = strrep(item_id_str, '.', '_'); % replace
        item_details = listStructTrain(j).details;
        item_score = listStructTrain(j).score;
        item_matDataPC1 = listStructTrain(j).matDataPcAll(:, 1); % ```注意```：此处的PC1是按照 mean_all std_all 而非trainDataset，不过当train/test 同分布时，没有问题
        item_matDataPC2 = listStructTrain(j).matDataPcAll(:, 2); 
        
        cur_neuron_id = cur_neuron.(item_id_str); % 当前neuron对应的一个场景要高亮显示的index
        
        % 是否显示那些 没有pattern的场景，注释时显示
%         if isempty(cur_neuron_id)
%             continue
%         end
        
        subplot(121)
        % 先把matDataPC1 plot
        plot(item_matDataPC1,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
        grid on; hold on;
        legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % 再高亮使neuron激活的部分
        if ~isempty(cur_neuron_id)
            plot(cur_neuron_id, item_matDataPC1(cur_neuron_id), 'ko', 'LineWidth', 1);
            legend_cell = [legend_cell, 'pattern'];
        end
        title(['neuron ', num2str(i), ', PC1']);
%         if ~isempty(legend_cell)
%             legend(legend_cell);
%         end
        
        subplot(122)
        % 先把matDataPC2 plot
        plot(item_matDataPC2,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
        grid on; hold on;
%         legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % 再高亮使neuron激活的部分
        if ~isempty(cur_neuron_id)
            plot(cur_neuron_id, item_matDataPC2(cur_neuron_id), 'ko', 'LineWidth', 1);
%         legend_cell = [legend_cell, 'pattern'];
        end
        title(['neuron ', num2str(i), ', PC2']);
        if ~isempty(legend_cell)
            legend(legend_cell);
        end
        
    end
    
end

end

