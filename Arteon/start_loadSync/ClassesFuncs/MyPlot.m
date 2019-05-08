classdef MyPlot
    % myArr�У�ÿһ��plot
    % ������ÿһ��signal��Ӧ�����г��������÷� plot
    
    properties
        m_Arr;
        m_signalTable;
        m_range_id; % Ҫplot�ĳ�������ʽΪ [ m : n]
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
            [maxV, minV] = mp.findMM(); % dataSArr ����score �� max��min������Ϊ��ͼʱ�߿��á�
%             amp = 10; % ��ͼʱ�ߴַ�������
            amp = mp.m_amp;
            
%             for idx_signal = 1 : height(mp.m_signalTable) 
            for idx_signal = mp.m_range_signal
                figure; % һ��signalһ��figure
                set(gcf, 'position', [50, -100, 1000, 800]);
                signalname_cell = mp.m_signalTable.signalName(idx_signal); 
                signalname = signalname_cell{1,1};
                signalunit_cell = mp.m_signalTable.unit(idx_signal);
                signalunit = signalunit_cell{1,1};

                legend_cell = {};
                i = 1;
                for item = mp.m_Arr % һ��signal��Ӧ���г��������ݣ�plot
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

