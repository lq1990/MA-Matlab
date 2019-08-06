function plot3DMatDataPcTime_tmp( listStructAll, range_id, pcs, amp )
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

    for i = 1 : 2 : length(pcs)
        
        pc = [i, i+1];
       plot3DFor2(listStructAll, range_id, pc, score_max, score_min, amp );

    end
end

