classdef MyPlot
    % myArr中，每一列plot
    % 即：将每一个signal对应的所有场景包含得分 plot
    
    properties
        m_Arr;
        m_signalTable;
        m_range_id; % 要plot的场景，格式为 [ m : n]
        m_range_signal;
        m_amp;
    end
    
    methods
        function mp = MyPlot(myArr, signalTable, range_id, range_signal, amp)
            disp('MyPlot...');
            mp.m_Arr = myArr;
            mp.m_signalTable = signalTable;
            mp.m_range_id = range_id;
            mp.m_range_signal = range_signal;
            mp.m_amp = amp;
        end
        
        function show(mp)
            [maxV, minV] = mp.findMM(); % dataSArr 所有score 中 max，min。留着为画图时线宽用。
%             amp = 10; % 画图时线粗方法倍数
            amp = mp.m_amp;
            
%             for idx_signal = 1 : height(mp.m_signalTable) 
            for idx_signal = mp.m_range_signal
                figure; % 一个signal一个figure
                set(gcf, 'position', [50, -100, 1000, 800]);
                signalname_cell = mp.m_signalTable.signalName(idx_signal); 
                signalname = signalname_cell{1,1};
                signalunit_cell = mp.m_signalTable.unit(idx_signal);
                signalunit = signalunit_cell{1,1};

                legend_cell = {};
                i = 1;
                for item = mp.m_Arr % 一个signal对应所有场景的数据，plot
                    if ~ismember(i, mp.m_range_id)
                         i = i+1;
                        continue
                    end
                    data = item.(signalname);
                    details = item.details;
                    score = item.score;
                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(data, 'LineWidth', (score-minV)/(maxV-minV)*amp+1); grid on; hold on;
                    
                    i = i+1;
                end

                title(signalname);
                xlabel('time, [s*10]');
                xlim([1 inf]);
                ylabel(signalunit);
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

