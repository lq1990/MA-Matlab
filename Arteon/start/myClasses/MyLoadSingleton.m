classdef MyLoadSingleton
    % 有些 id 共享一组数据时，没必要每个类都得重新load。
    % 希望load一次，所有类共享。
    % 比如 id 16 17 18
    
    properties
        m_file;
    end
    
    methods
    end
    
end

