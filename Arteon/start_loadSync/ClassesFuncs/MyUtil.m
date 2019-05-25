classdef MyUtil
    % utils that defined by myself
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function out = shuffleArr(arr)
            % shuffle rows of arr
            rand('seed',2);
            randIdx = randperm(size(arr,1));
            out = arr(randIdx, :);
        end
        
        function out = shuffleStruct(s)
            % shuffle rows of struct
            rand('seed',3);
            randIdx = randperm(length(s));
            out = s(randIdx);
        end
        
        function out = shuffleListStruct(in, seed)
            % shuffle rows of listStruct
            rand('seed', seed);
            randIdx = randperm(length(in));
            out = in(randIdx);
        end
        
    end
    
    
    
end
