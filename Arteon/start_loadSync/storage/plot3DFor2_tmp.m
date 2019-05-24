function plot3DFor2(listStructAll, range_id, pcs, score_max, score_min, amp )
    % pcs: [pc1, pc2] or [pc3, pc4] or ...
    figure;
    legend_cell = {};
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

        pc1 = item.matDataPcAll(:, pcs(1));
        pc2 = item.matDataPcAll(:, pcs(2));
        time = (1:length(pc1))';

        legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
        plot3(time, pc1, pc2, linetyp, 'LineWidth', (score - score_min)/(score_max-score_min + 1e-8)*amp +0.5); 
        grid on; hold on;

    end

    xlabel('time');
    ylabel(['PC', num2str(pcs(1))]);
    zlabel(['PC', num2str(pcs(2))]);
    legend(legend_cell);
end

