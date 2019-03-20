classdef yearE7
    %YEARE7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Value = 1;
        LeapYear = false;
        M = [31 28 31 30 31 30 31 31 30 31 30 31];
    end
    
    methods
        function Y = yearE7(Yv) % contructor。实例名为 Y
            if nargin == 1
                if isscalar(Yv) && isnumeric(Yv) && floor(Yv) == ceil(Yv) && Yv > 0
                    Y.Value = Yv;
                    Y.LeapYear = rem(Yv, 4) == 0 && (rem(Yv,100)~=0 || rem(Yv,400)==0);
                    if Y.LeapYear
                        Y.M(2) = 29;
                    end
                elseif isa(Yv, 'yearE7') % 如果Yv 已经是 yearE7对象，直接传回去
                    Y = Yv;
                    
                else
                    error('invalid Yv')
                end
            end
            
        end
        
        function N = nDays(Y) % N 直接 return
            N = sum(Y.M);
        end
        function C = char(Y)
            C = int2str(Y.Value);
        end
        function display(Y) % override了默认的 display方法
            disp(['yearE7: ' char(Y)])
        end
        function [d,m] = n2dm(Y, Nday) % 每个函数都有Y,类比如 python中self，此为实例
            cM = cumsum(Y.M);
            m = find(Nday <= cM,1); % 找满足条件的 第一个数
            d = Nday - sum(Y.M(1: m-1));
        end
        
    end
end

