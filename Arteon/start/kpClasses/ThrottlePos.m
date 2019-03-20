classdef ThrottlePos
    %AX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function tp = ThrottlePos() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.throttle_pos , 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '%';
            tmp_title = 'Throttle Position';
            
        end
    end
    
end

