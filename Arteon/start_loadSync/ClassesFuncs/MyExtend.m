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
            
            if me.m_factor == 1
                newData = me.m_data;
            elseif me.m_factor > 1
                % factor >= 1，意味着是 upsampling
                % 方法：自己写的 线性插值
                newData = MyExtend.myInterp(me.m_data, me.m_factor);
                
                % 上采样方法：重复前面最近的值
%                 for i = 1:length(me.m_data)
%                     for j = 1:me.m_factor
%                         newData = [newData; me.m_data(i)];
%                     end
%                 end
                
            else
                % 否则是 downsampling
                tmp_factor = round(1/me.m_factor); % 将小数factor转换
                
                % 下采样方法：直接取一段间隔的一个数。没有算均值
                for i = 1: tmp_factor :length(me.m_data)
                    newData = [newData; me.m_data(i)];
                end
                
%                 for i = 1:length(me.m_data)
%                     if mod(i, tmp_factor) == 1
%                         % 下采样方法：直接取一段间隔的一个数。没有算均值
%                         newData = [newData; me.m_data(i)];
%                     end
%                 end

            end
            
            out = newData;
        end
 
    end
    
    
    methods(Static)
        function out = myInterp(data, factor )
            % my Interpolation by LinearSpline
            % since function interp1() in matlab is too slow, I write this m-file.
            % factor 扩展几倍，factor要大于1。上采样
            % 扩展方式：把两个相邻点间距，分成factor份。
            % 对于数据和time都可用。

            [n_rows, n_cols] = size(data);

            data_new = zeros(n_rows, n_cols); % init 列向量

            for i = 1:length(data)
                if i==1
                    data_new(1) = data(1);
                    continue
                end
                % 从第二个点开始

                i_new = (i-1)*factor +1;

                for j = 1:factor
                    data_new(i_new-(factor-j)) = ( data(i)-data(i-1) ) / factor * j +data(i-1);
                end
            end

            out = data_new;
        end

    end
    
end
