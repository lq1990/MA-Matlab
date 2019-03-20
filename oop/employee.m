classdef employee
    
    % classdef advantages: control the properties
    properties % ÀàµÄÊôĞÔ£¬public by default
        Name  % default value is empty
        Category = 'Trainee' % defalut 'Trainee'
        IDNumber
        p1 = 0;
    end
    methods
        function E = set.Name(E, name)
            if ischar(name) && ndims(name)==2 && size(name,1)==1
                E.Name = name;
            else
                error('invalid Name')
            end
        end
        function E = set.Category(E, newCategory)
            options  = {'Trainee','Intern','PartTime','Career','Manager','CEO'};
            switch newCategory
                case options
                    E.Category = newCategory;
                otherwise
                      error('invalid Category');
            end
        end
        function E = set.IDNumber(E, idn)
            if isnumeric(idn) && isscalar(idn) && ceil(idn)==floor(idn) && idn>0
                E.IDNumber = idn;
            else
                error('invalid IDNumber')
            end
        end
        
    end
    
end