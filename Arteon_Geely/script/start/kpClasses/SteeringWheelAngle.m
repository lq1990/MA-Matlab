classdef SteeringWheelAngle

    properties
    end
    
    methods
        function swa = SteeringWheelAngle() % constructor
            
        end
    end
    
    methods(Static=true)
        function [tmp_ylabel, tmp_title] = plot(item, maxV, minV, amp)
            plot(item.steering_wheel_angle, 'LineWidth', (item.score-minV)/(maxV-minV)*amp+0.1);
            tmp_ylabel =  'Grad';
            tmp_title = 'Steering Wheel Angle';
            
        end
    end
    
end

