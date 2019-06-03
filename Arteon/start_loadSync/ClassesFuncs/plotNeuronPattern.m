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
    
    % ���ѭ��ȡ��ÿ��neuron��һ��neuronһ��figure
    figure;
    set(gcf, 'position', [500, -100, 1000, 800]);
    cur_neuron = neuronPatternSArr(i);
    
    legend_cell = {};
    for j = 1 : length(listStructTrain)
        if ~ismember(j, range_id)
            continue
        end
        
        % �ڲ�ѭ������ÿ�������������listStruct�õ� id
        item_id = listStructTrain(j).id;
        item_id_str = ['id', num2str(item_id)];
        item_id_str = strrep(item_id_str, '.', '_'); % replace
        item_details = listStructTrain(j).details;
        item_score = listStructTrain(j).score;
        item_matDataPC1 = listStructTrain(j).matDataPcAll(:, 1); % ```ע��```���˴���PC1�ǰ��� mean_all std_all ����trainDataset��������train/test ͬ�ֲ�ʱ��û������
        item_matDataPC2 = listStructTrain(j).matDataPcAll(:, 2); 
        
        cur_neuron_id = cur_neuron.(item_id_str); % ��ǰneuron��Ӧ��һ������Ҫ������ʾ��index
        
        % �Ƿ���ʾ��Щ û��pattern�ĳ�����ע��ʱ��ʾ
%         if isempty(cur_neuron_id)
%             continue
%         end
        
        subplot(121)
        % �Ȱ�matDataPC1 plot
        plot(item_matDataPC1,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
        grid on; hold on;
        legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % �ٸ���ʹneuron����Ĳ���
        if ~isempty(cur_neuron_id)
            plot(cur_neuron_id, item_matDataPC1(cur_neuron_id), 'ko', 'LineWidth', 1);
            legend_cell = [legend_cell, 'pattern'];
        end
        title(['neuron ', num2str(i), ', PC1']);
%         if ~isempty(legend_cell)
%             legend(legend_cell);
%         end
        
        subplot(122)
        % �Ȱ�matDataPC2 plot
        plot(item_matDataPC2,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
        grid on; hold on;
%         legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
        % �ٸ���ʹneuron����Ĳ���
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

