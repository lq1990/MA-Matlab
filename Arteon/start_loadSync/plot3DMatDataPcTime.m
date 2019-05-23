function plot3DMatDataPcTime( listStructAll, range_id, amp )
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

    legend_cell = {};
    figure;
    for i = 1 : length(listStructAll)
         if ~ismember(i, range_id)
            continue
         end

        item = listStructAll(i);
        id = item.id;
        score = item.score;
        details = item.details;
        
        % line type
        idstr = num2str(id);
        if idstr(1) == '1' % Arteon
            linetyp = '-';
        else % Geely
            linetyp = '-.';
        end

        pc1 = item.matDataPc(:, 1);
        pc2 = item.matDataPc(:, 2);
        time = (1:length(pc1))';

        legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
        plot3(time, pc1, pc2, linetyp, 'LineWidth', (score - score_min)/(score_max-score_min + 1e-8)*amp +0.5); 
        grid on; hold on;

    end

    xlabel('time');
    ylabel('pc1');
    zlabel('pc2');
    legend(legend_cell);


end

