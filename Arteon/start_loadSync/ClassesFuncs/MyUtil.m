classdef MyUtil
    % utils that defined by myself
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function out = shuffleArr(arr)
            % shuffle rows of arr
            randIdx = randperm(size(arr,1));
            out = arr(randIdx, :);
        end
        
        function out = shuffleStruct(s)
            % shuffle rows of struct
            randIdx = randperm(length(s));
            out = s(randIdx);
        end
    end
    
end
