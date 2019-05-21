classdef MySignal
    % MySignal Class, load dir, read signal from workspace
    properties
        m_ds; % load����֮��� dataStruct
        m_signal; % signalSyncName, from signalTable, 
        m_signal_time; % signalTimeName
        m_car_type; % 'Arteon', 'Geely'
    end
    
    methods
        function ms = MySignal(ds, signal, signal_time, car_type)
            ms.m_ds = ds;
            ms.m_signal = signal;
            ms.m_signal_time = signal_time;
            ms.m_car_type = car_type;
        end
        
        function loadData = load(ms)
            % ��ds�ж�ȡһ��signal
            loadData = ms.m_ds.(ms.m_signal);
        end
        
        function lfData = load_filter(ms, cut_off)
            loadData = ms.load();
            % ����
            mf = MyFilter(loadData, cut_off); % cut_off: 13 ~15 Hz
            lfData = mf.filter();
            fprintf('filtering > signalSyncName: %s\n', ms.m_signal);
        end
        
        function leData = load_extend(ms, factor)
            loadData = ms.load();
            
            me = MyExtend(loadData, factor);
            leData = me.extend();
        end
        
        function out = load_filter_extend(ms, cut_off, factor)
            loadData = ms.load();
            
            % extend firstly, then filter
            me = MyExtend(loadData, factor);
            exData = me.extend();
            
            mf = MyFilter(exData, cut_off); % cut_off: 13 ~15 Hz
            fprintf('filtering > signalSyncName: %s\n', ms.m_signal);
            
            out = mf.filter();
        end
        
        function [idx_t_begin, idx_t_end] = findIdxTT(ms, t_begin, t_end, factor, samplingFactor)
            % samplingFactor���²������Ƶ��ֵ��Ϊ10hz.
            % �ҵ� t_begin ,t_end ��Ӧ��idx����idx�� �ź�val��ȡֵ
            % load t
            tData = ms.m_ds.(ms.m_signal_time); 
            % extend t
            me = MyExtend(tData, factor);
            texData = me.extend();
            % find t ��Ӧ�� idx
            % 0.09 - 10hz, 0.009 - 100hz
            idx_t_begin = find( abs(texData-t_begin) <1/samplingFactor, 1); %   < val �����ã���Ӱ�� t_beginʱ��FP��ֵ��ϣ��FP��ʼΪ0
            
            % ԭʼ����Ƶ�� 100hz
            dt = round((t_end - t_begin) * samplingFactor); % �²�����10hz
            % ���� idx_t_end�����ǰ���һ������ ===============================
            % idx_t_end = find( abs(texData-t_end) <0.06, 1 ); 
            % ���ڲ���Ƶ�ʲ�ͬ���£����������һ�м��㣬����signal�������в�ͬ��
            % ʹ����һ�У���ͳһ����
            idx_t_end = dt + idx_t_begin;
            
            %% �ҵ� ����Ϊ30km/hʱ�� idx_v30���� idx_v30, idx_t_end��ѡ�� С��
            % �� idx_t_begin ~ idx_t_end ��Χ�� �ҵ�����Լ���� 30��idx����Ϊ�µ� idx_t_end
            % Ϊ����ⷽ�㣬ֱ����dataStruct.m�в���
     
        end
        
    end
    
    methods(Static)
        % filter, extend
        
    end
    
    
end
