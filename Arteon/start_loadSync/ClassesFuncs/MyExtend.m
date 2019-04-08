classdef MyExtend
    % if factor >= 1 upsampling, else downsampling
    properties
        m_data;
        m_factor; % 需要扩展的倍数
    end
    
    methods
        function me = MyExtend(data, factor)
            me.m_data = data;
            me.m_factor = factor;
        end
        
        function out = extend(me)
            newData = [];
            
            if me.m_factor >= 1
                % factor >= 1，意味着是 upsampling
                % 上采样方法：重复前面最近的值
                for i = 1:length(me.m_data)
                    for j = 1:me.m_factor
                        newData = [newData; me.m_data(i)];
                    end
                end
                
            else
                % 否则是 downsampling
                tmp_factor = round(1/me.m_factor); % 将小数factor转换
                for i = 1:length(me.m_data)
                    if mod(i, tmp_factor) == 1
                        % 下采样方法：直接取一段间隔的一个数。没有算均值
                        newData = [newData; me.m_data(i)];
                    end
                end
                
            end
              
            
            
            out = newData;
        end
        
 
    end
    
end

