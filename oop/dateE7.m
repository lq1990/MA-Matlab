classdef dateE7
    properties (Access=private)
        day = 1
        month = 1
        year = yearE7(1)
    end
    
    methods
        function D = dateE7(d, m, y)
            D.year = yearE7(y);
            D.month = m;
            D.day = d;
        end
        
    end
    
    methods (Static=true, Access=private) 
        function charMonth = m2m(nMonth) 
            % static method, dateE7.m2m to call it
            M = ['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep';...
                'Okt'; 'Nov'; 'Dec'];
            charMonth = M(nMonth, :);
        end
    end
     
end