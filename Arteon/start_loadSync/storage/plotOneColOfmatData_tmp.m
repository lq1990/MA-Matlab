function out_legend_cell = plotOneColOfmatData_tmp( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend )
    figure(figureID);
    subplot(subplotID);
    
    plot(item_matData,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
    grid on; hold on;
    if ifShowLegend==1 % 只有要show legend的那个figure才有必要存储legend_cell
        legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
    end
    % 再高亮使neuron激活的部分
    if ~isempty(cur_neuron_id)
        plot(cur_neuron_id, item_matData(cur_neuron_id), 'k*', 'LineWidth', 2);
        
        if ifShowLegend==1
            legend_cell = [legend_cell, 'pattern'];
        end
    end
    title(['neuron ', num2str(i), ', ', signalName]);
    
    out_legend_cell = legend_cell;
end
