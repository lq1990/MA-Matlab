classdef SteeringWheelSpeed

    properties
    end
    
    methods
        function sws = SteeringWheelSpeed() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.steering_wheel_speed, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'Grad/s';
            tmp_title = 'Steering Wheel Speed';
            
        end
    end
    
end

