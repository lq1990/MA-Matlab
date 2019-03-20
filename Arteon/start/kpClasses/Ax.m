classdef Ax
    %AX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function ax = Ax() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.ax, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'm/s^2';
            tmp_title = 'Longitual Accelaration';
            
        end
    end
    
end

