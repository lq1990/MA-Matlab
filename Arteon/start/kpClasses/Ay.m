classdef Ay
    %AX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function ay = Ay() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.ay, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'm/s^2';
            tmp_title = 'Lateral Accelaration';
            
        end
    end
    
end

