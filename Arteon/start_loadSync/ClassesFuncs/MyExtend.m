classdef MyExtend
    % if factor >= 1 upsampling, else downsampling
    properties
        m_data;
        m_factor; % ��Ҫ��չ�ı���
    end
    
    methods
        function me = MyExtend(data, factor)
            me.m_data = data;
            me.m_factor = factor;
        end
        
        function out = extend(me)
            newData = [];
            
            if me.m_factor >= 1
                % factor >= 1����ζ���� upsampling
                % �ϲ����������ظ�ǰ�������ֵ
                for i = 1:length(me.m_data)
                    for j = 1:me.m_factor
                        newData = [newData; me.m_data(i)];
                    end
                end
                
            else
                % ������ downsampling
                tmp_factor = round(1/me.m_factor); % ��С��factorת��
                for i = 1:length(me.m_data)
                    if mod(i, tmp_factor) == 1
                        % �²���������ֱ��ȡһ�μ����һ������û�����ֵ
                        newData = [newData; me.m_data(i)];
                    end
                end
                
            end
              
            
            
            out = newData;
        end
        
 
    end
    
end

