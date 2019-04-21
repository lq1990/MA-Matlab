classdef MySignal
    % MySignal Class, load dir, read signal from workspace
    properties
        m_ds; % dataStruct
        m_signal; % signalSyncName, from signalTable, 
        m_signal_time; % signalTimeName
    end
    
    methods
        function ms = MySignal(ds, signal, signal_time)
            ms.m_ds = ds;
            ms.m_signal = signal;
            ms.m_signal_time = signal_time;
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
        
        function lfeData = load_filter_extend(ms, cut_off, factor)
            loadData = ms.load();
            
            mf = MyFilter(loadData, cut_off); % cut_off: 13 ~15 Hz
            lfData = mf.filter();
            fprintf('filtering > signalSyncName: %s\n', ms.m_signal);
            
            me = MyExtend(lfData, factor);
            lfeData = me.extend();
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
            idx_t_begin = find( abs(texData-t_begin) <0.09, 1); %   < val �����ã���Ӱ�� t_beginʱ��FP��ֵ��ϣ��FP��ʼΪ0
            
            % ԭʼ����Ƶ�� 100hz
            dt = round((t_end - t_begin) * samplingFactor); % �²�����10hz
            % ���� idx_t_end�����ǰ���һ������ ===============================
            % idx_t_end = find( abs(texData-t_end) <0.06, 1 ); 
            % ���ڲ���Ƶ�ʲ�ͬ���£����������һ�м��㣬����signal�������в�ͬ��
            % ʹ����һ�У���ͳһ����
            idx_t_end = dt + idx_t_begin;
     
        end
    end
    
end