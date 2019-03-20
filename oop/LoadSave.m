classdef LoadSave
    properties (Access=private)
        a = 0;
        b = 0;
    end
    
    methods
        function ls = LoadSave(a ,b)
            ls.a = a;
            ls.b = b;
        end
        
        function res = getSumMul(ls)
            sum = ls.a + ls.b;
            res = sum* LoadSave.getMul(ls.a,  ls.b);
        end
    end
    
    methods (Static = true, Access=private)
         function mul = getMul(a, b)
            mul = a*b;
        end
    end

end
