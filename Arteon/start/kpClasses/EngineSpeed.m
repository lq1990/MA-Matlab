classdef EngineSpeed
    
    properties
        
    end
    
    methods
        function es = EngineSpeed() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.engine_speed, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '1/min';
            tmp_title = 'Engine Speed';
            
            
        end
    end
    
end

