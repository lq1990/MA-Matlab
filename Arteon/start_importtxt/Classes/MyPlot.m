classdef MyPlot
    % myArr�У�ÿһ��plot
    % ������ÿһ��kp��Ӧ�����г��������÷� plot
    
    properties
        m_Arr;
        m_kpTable;
        m_range_id; % Ҫplot�ĳ�������ʽΪ [ m : n]
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
            [maxV, minV] = mp.findMM(); % dataSArr ����score �� max��min������Ϊ��ͼʱ�߿��á�
            amp = 10; % ��ͼʱ�ߴַ�������
            
%             for idx_kp = 1 : height(mp.m_kpTable) 
            for idx_kp = mp.m_range_kp
                figure; % һ��kpһ��figure
                kpname_cell = mp.m_kpTable.kpName(idx_kp); 
                kpname = kpname_cell{1,1};
                kpunit_cell = mp.m_kpTable.unit(idx_kp);
                kpunit = kpunit_cell{1,1};

                legend_cell = {};
                i = 1;
                for item = mp.m_Arr % һ��kp��Ӧ���г��������ݣ�plot
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
            % �ҵ���ѡ��� ���г����ĵ÷������Сֵ��
            score_list = [];
            i = 1;
            for item = mp.m_Arr
                if ~ismember(i, mp.m_range_id) % ���û��ѡ��
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

