function plotMatDataPcEachSce( listStructAll, range_id, pcs, amp)

    score_list = [];
    for i = 1 : length(listStructAll)
        if ~ismember(i, range_id)
            continue
        end
        
        item = listStructAll(i);
        score_list = [score_list; item.score];
    end
    score_max = max(score_list);
    score_min = min(score_list);

    for pc = pcs
        % 一个pc一个图
        figure;
        set(gcf, 'position', [50, -100, 1000, 800]);
        legend_cell = {};
        for i = 1:length(listStructAll)
            if ~ismember(i, range_id)
                continue
            end

            item = listStructAll(i);
            id = item.id;
            score = item.score;
            details = item.details;
            matDataPc = item.matDataPcAll(:, pc);
            
            idstr = num2str(id);
            if idstr(1) == '1' % Arteon
                linetyp = '-';
            else % Geely
                linetyp = '-.';
            end

            legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
            plot(matDataPc, linetyp, 'LineWidth', (score - score_min)/(score_max-score_min + 1e-8)*amp +0.5 );
            grid on; hold on;
        end

        title(['PC', num2str(pc)]);
        legend(legend_cell);
        xlabel('time. sampling freq: 100hz'); 
     end
end

