classdef AccPedal
    %AX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function ap = AccPedal() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.acc_pedal, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '%';
            tmp_title = 'Acceleration Pedal Position';
            
        end
    end
    
end

