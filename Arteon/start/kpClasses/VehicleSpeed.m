classdef VehicleSpeed

    properties
    end
    
    methods
        function vs = VehicleSpeed() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.vehicle_speed, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'km/h';
            tmp_title = 'Vehicle Speed';
            
        end
    end
    
end

