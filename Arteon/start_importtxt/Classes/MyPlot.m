classdef MyPlot
    % myArr中，每一列plot
    % 即：将每一个kp对应的所有场景包含得分 plot
    
    properties
        m_Arr;
        m_kpTable;
        m_range_id; % 要plot的场景，格式为 [ m : n]
        m_range_kp;
    end
    
    methods
        function mp = MyPlot(myArr, kpTable, range_id, range_kp)
            mp.m_Arr = myArr;
            mp.m_kpTable = kpTable;
            mp.m_range_id = range_id;
            mp.m_range_kp = range_kp;
        end
        
        function show(mp)
            [maxV, minV] = mp.findMM(); % dataSArr 所有score 中 max，min。留着为画图时线宽用。
            amp = 10; % 画图时线粗方法倍数
            
%             for idx_kp = 1 : height(mp.m_kpTable) 
            for idx_kp = mp.m_range_kp
                figure; % 一个kp一个figure
                kpname_cell = mp.m_kpTable.kpName(idx_kp); 
                kpname = kpname_cell{1,1};
                kpunit_cell = mp.m_kpTable.unit(idx_kp);
                kpunit = kpunit_cell{1,1};

                legend_cell = {};
                i = 1;
                for item = mp.m_Arr % 一个kp对应所有场景的数据，plot
                    if ~ismember(i, mp.m_range_id)
                         i = i+1;
                        continue
                    end
                    data = item.(kpname);
                    details = item.details;
                    score = item.score;
                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(data, 'LineWidth', (score-minV)/(maxV-minV)*amp+1); grid on; hold on;
                    
                    i = i+1;
                end

                title(kpname);
                ylabel(kpunit);
                legend(legend_cell);
            end
        end
        
        function [maxV, minV] = findMM(mp)
            % 找到被选择的 所有场景的得分最大、最小值。
            score_list = [];
            i = 1;
            for item = mp.m_Arr
                if ~ismember(i, mp.m_range_id) % 如果没被选择
                     i = i+1;
                    continue
                end
                score_list = [score_list, item.score];
                i = i+1;
            end
            maxV = max(score_list);
            minV = min(score_list);
        end

    end
    
end

