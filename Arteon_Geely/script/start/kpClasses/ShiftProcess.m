classdef ShiftProcess

    properties
    end
    
    methods
        function sp = ShiftProcess() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.shift_process, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  '-';
            tmp_title = 'Shift Process';
            
        end
    end
    
end

