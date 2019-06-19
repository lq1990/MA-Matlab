function plotNeuronPatternRawSignals( listStructTrain, neuronPatternSArr, signalTable, range_neurons, range_id )
    % plot the part of scenarios that activate a neuron
    % this part of scenario is called pattern.
    % labels depends on  recombination of different patterns 
    % many figures and subplot to show raw signals.
    amp = 5;
    [ score_min, score_max ] = MyPlot.findScoreMinMaxOfListStruct(listStructTrain, range_id);

for i = 1 : length(neuronPatternSArr)
    % loop over every neuron
    if ~ismember(i, range_neurons)
        continue
    end
    
    % 外层循环取得每个neuron，一个neuron一个figure
    figureid1 = i + 0*length(neuronPatternSArr);
    figureid2 = i + 1*length(neuronPatternSArr);
    figureid3 = i + 2*length(neuronPatternSArr);
    figureid_list = [figureid1, figureid2, figureid3];
    
    figure(figureid_list(1));
    set(gcf, 'position', [200, -150, 1400, 900]);
    figure(figureid_list(2));
    set(gcf, 'position', [300, -200, 1400, 900]);
    figure(figureid_list(3));
    set(gcf, 'position', [400, -250, 1400, 900]);
    
    cur_neuron = neuronPatternSArr(i);
    
    legend_cell = {};
    for j = 1 : length(listStructTrain)
        if ~ismember(j, range_id)
            continue
        end
        
        % 内层循环遍历每个场景，需借助listStruct拿到 id
        item_id = listStructTrain(j).id; fprintf('item_id: %d\n', item_id);
        item_id_str = ['id', num2str(item_id)];
        item_id_str = strrep(item_id_str, '.', '_'); % replace
        item_details = listStructTrain(j).details;
        item_score = listStructTrain(j).score;
        
        cur_neuron_id = cur_neuron.(item_id_str); % 当前neuron对应的一个场景要高亮显示的index
                
        % 是否显示那些 没有pattern的场景，注释时显示
%         if isempty(cur_neuron_id)
%             continue
%         end

        
        % plot each column of matData to know the raw signals better
        for i_signal = 1 : height(signalTable)
            figureID = figureid_list( ceil(i_signal/6) );
            subplotID = 230+mod(i_signal - 1, 6)+1;
            item_matData = listStructTrain(j).matData(:, i_signal);
            signalName = signalTable.signalName(i_signal);
            if i_signal==1
                % legend_cell 在这个for内部 只更新一次。避免受for影响。
                ifShowLegend = 1;
                legend_cell = plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );
            else
                ifShowLegend = 0;
                legend_cell = plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );
            end
            
        end
        
       
%         
%         item_matData01 = listStructTrain(j).matData(:, 1);
%         item_matData02 = listStructTrain(j).matData(:, 2);
% 
% 
%         figureID = figureid1;
%         subplotID = 231;
%         item_matData = item_matData01;
%         signalName = 'signal01';
%         ifShowLegend = 1;
%         legend_cell = plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );
% 
%         figureID = figureid1;
%         subplotID = 232;
%         item_matData = item_matData02;
%         signalName = 'signal02';
%         ifShowLegend = 0;
%         legend_cell = plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );

    end
    
      if ~isempty(legend_cell)
            legend(legend_cell);
      end
    
end

end

