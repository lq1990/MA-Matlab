classdef KickDown

    properties
    end
    
    methods
        function kd = KickDown() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.kick_down, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '0 or 1';
            tmp_title = 'Kick Down';
            
        end
    end
    
end

