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
        
        function [ prob_list, idx_list ] = findFirstThreeHighValAndIdx(list)
            % 注意matlab从1开始idx计数
            prob_list = [];
            idx_list = [];

            for i = 1:3
                [prob, idx] = max(list);
                prob_list = [prob_list, prob];
                idx_list = [idx_list, idx];
                list(idx) = 0;
            end
        end
    end
    
    
    
end
