classdef MySignal
    % MySignal Class, load dir, read signal from workspace
    properties
        m_ds; % load进来之后的 dataStruct
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
            % 从ds中读取一个signal
            loadData = ms.m_ds.(ms.m_signal);
        end
        
        function lfData = load_filter(ms, cut_off)
            loadData = ms.load();
            % 过滤
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
            % samplingFactor：下采样后的频率值，为10hz.
            % 找到 t_begin ,t_end 对应的idx，用idx从 信号val中取值
            % load t
            tData = ms.m_ds.(ms.m_signal_time); 
            % extend t
            me = MyExtend(tData, factor);
            texData = me.extend();
            % find t 对应的 idx
            % 0.09 - 10hz, 0.009 - 100hz
            idx_t_begin = find( abs(texData-t_begin) <1/samplingFactor, 1); %   < val 的设置，会影响 t_begin时刻FP的值，希望FP起始为0
            
            % 原始采样频率 100hz
            dt = round((t_end - t_begin) * samplingFactor); % 下采样后，10hz
            % 不求 idx_t_end，而是按照一个长度 ===============================
            % idx_t_end = find( abs(texData-t_end) <0.06, 1 ); 
            % 由于采样频率不同导致，如果按照上一行计算，各个signal长度略有不同。
            % 使用下一行，可统一长度
            idx_t_end = dt + idx_t_begin;
            
            %% 找到 车速为30km/h时的 idx_v30，在 idx_v30, idx_t_end中选择 小的
            % 在 idx_t_begin ~ idx_t_end 范围内 找到车速约等于 30的idx，作为新的 idx_t_end
            % 为了理解方便，直接在dataStruct.m中操作
     
        end
        
    end
    
    methods(Static)
        % filter, extend
        
    end
    
    
end
