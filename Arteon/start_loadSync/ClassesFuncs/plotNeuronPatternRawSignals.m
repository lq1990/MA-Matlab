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
    
    % ���ѭ��ȡ��ÿ��neuron��һ��neuronһ��figure
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
        
        % �ڲ�ѭ������ÿ�������������listStruct�õ� id
        item_id = listStructTrain(j).id; fprintf('item_id: %d\n', item_id);
        item_id_str = ['id', num2str(item_id)];
        item_id_str = strrep(item_id_str, '.', '_'); % replace
        item_details = listStructTrain(j).details;
        item_score = listStructTrain(j).score;
        
        cur_neuron_id = cur_neuron.(item_id_str); % ��ǰneuron��Ӧ��һ������Ҫ������ʾ��index
                
        % �Ƿ���ʾ��Щ û��pattern�ĳ�����ע��ʱ��ʾ
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
                % legend_cell �����for�ڲ� ֻ����һ�Ρ�������forӰ�졣
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

