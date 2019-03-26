classdef MyPlot
    % myArr中，每一列plot
    % 即：将每一个kp对应的所有场景包含得分 plot
    
    properties
        m_Arr;
        m_kpTable;
    end
    
    methods
        function mp = MyPlot(myArr, kpTable)
            mp.m_Arr = myArr;
            mp.m_kpTable = kpTable;
        end
        
        function showAllKp(mp)
            [maxV, minV] = mp.findMM(); % dataSArr 所有score 中 max，min。留着为画图时线宽用。
            amp = 10; % 画图时线粗方法倍数
            
            for idx_kp = 1 : height(mp.m_kpTable) 
                figure; % 一个kp一个figure
                kpname_cell = mp.m_kpTable.kpName(idx_kp); 
                kpname = kpname_cell{1,1};
                kpunit_cell = mp.m_kpTable.unit(idx_kp);
                kpunit = kpunit_cell{1,1};

                legend_cell = {};
                for item = mp.m_Arr
                    data = item.(kpname);
                    details = item.details;
                    score = item.score;
                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(data, 'LineWidth', (score-minV)/(maxV-minV)*amp+0.1); grid on; hold on;
                end

                title(kpname);
                ylabel(kpunit);
                legend(legend_cell);
            end
        end
        
        function [maxV, minV] = findMM(mp)
            score_list = [];
            for item = mp.m_Arr
                score_list = [score_list, item.score];
            end
            maxV = max(score_list);
            minV = min(score_list);
        end

    end
    
end

