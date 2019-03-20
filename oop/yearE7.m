classdef yearE7
    %YEARE7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Value = 1;
        LeapYear = false;
        M = [31 28 31 30 31 30 31 31 30 31 30 31];
    end
    
    methods
        function Y = yearE7(Yv) % contructor��ʵ����Ϊ Y
            if nargin == 1
                if isscalar(Yv) && isnumeric(Yv) && floor(Yv) == ceil(Yv) && Yv > 0
                    Y.Value = Yv;
                    Y.LeapYear = rem(Yv, 4) == 0 && (rem(Yv,100)~=0 || rem(Yv,400)==0);
                    if Y.LeapYear
                        Y.M(2) = 29;
                    end
                elseif isa(Yv, 'yearE7') % ���Yv �Ѿ��� yearE7����ֱ�Ӵ���ȥ
                    Y = Yv;
                    
                else
                    error('invalid Yv')
                end
            end
            
        end
        
        function N = nDays(Y) % N ֱ�� return
            N = sum(Y.M);
        end
        function C = char(Y)
            C = int2str(Y.Value);
        end
        function display(Y) % override��Ĭ�ϵ� display����
            disp(['yearE7: ' char(Y)])
        end
        function [d,m] = n2dm(Y, Nday) % ÿ����������Y,����� python��self����Ϊʵ��
            cM = cumsum(Y.M);
            m = find(Nday <= cM,1); % ������������ ��һ����
            d = Nday - sum(Y.M(1: m-1));
        end
        
    end
end

