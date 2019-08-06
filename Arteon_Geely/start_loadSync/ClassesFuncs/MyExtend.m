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
            
            if me.m_factor == 1
                newData = me.m_data;
            elseif me.m_factor > 1
                % factor >= 1����ζ���� upsampling
                % �������Լ�д�� ���Բ�ֵ
                newData = MyExtend.myInterp(me.m_data, me.m_factor);
                
                % �ϲ����������ظ�ǰ�������ֵ
%                 for i = 1:length(me.m_data)
%                     for j = 1:me.m_factor
%                         newData = [newData; me.m_data(i)];
%                     end
%                 end
                
            else
                % ������ downsampling
                tmp_factor = round(1/me.m_factor); % ��С��factorת��
                
                % �²���������ֱ��ȡһ�μ����һ������û�����ֵ
                for i = 1: tmp_factor :length(me.m_data)
                    newData = [newData; me.m_data(i)];
                end
                
%                 for i = 1:length(me.m_data)
%                     if mod(i, tmp_factor) == 1
%                         % �²���������ֱ��ȡһ�μ����һ������û�����ֵ
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
            % factor ��չ������factorҪ����1���ϲ���
            % ��չ��ʽ�����������ڵ��࣬�ֳ�factor�ݡ�
            % �������ݺ�time�����á�

            [n_rows, n_cols] = size(data);

            data_new = zeros(n_rows, n_cols); % init ������

            for i = 1:length(data)
                if i==1
                    data_new(1) = data(1);
                    continue
                end
                % �ӵڶ����㿪ʼ

                i_new = (i-1)*factor +1;

                for j = 1:factor
                    data_new(i_new-(factor-j)) = ( data(i)-data(i-1) ) / factor * j +data(i-1);
                end
            end

            out = data_new;
        end

    end
    
end
