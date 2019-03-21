classdef BrakePressureRaw

    properties
    end
    
    methods
        function bpr = BrakePressureRaw() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.brake_pressure_raw, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'bar';
            tmp_title = 'Brake Pressure Raw Value';
            
        end
    end
    
end

