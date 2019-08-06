classdef TargetGear

    properties
    end
    
    methods
        function tg = TargetGear() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.target_gear, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '-';
            tmp_title = 'Target Gear';
            
        end
    end
    
end

