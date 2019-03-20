classdef TransmissionInputSpeed

    properties
    end
    
    methods
        function tis = TransmissionInputSpeed() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.transmission_input_speed, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '1/min';
            tmp_title = 'Transmission Input Speed';
            
        end
    end
    
end

