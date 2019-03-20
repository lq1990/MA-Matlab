classdef EngineTorque

    properties
    end
    
    methods
        function et = EngineTorque() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.engine_torque, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'Nm';
            tmp_title = 'Engine Torque';
            
        end
    end
    
end

