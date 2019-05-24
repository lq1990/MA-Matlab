classdef MyListStruct
    % 有关 listStruct  的操作
    % listStruct: [{id, score, details, matData, ... },{...},...]
    % 用list保存，方便取值，乱序 等
    
    properties
    end
    
    methods
    end
    
    
    methods(Static)
        function out = addMatDataZScore( listStruct, meanVec, stdVec )
            % for listStructTrain and listStructTest

            for i = 1 : length(listStruct)

                item = listStruct(i);
                mean_train_rep = repmat(meanVec, length(item.matData),1);
                std_train_rep = repmat(stdVec, length(item.matData),1);

                i_matDataZScore = (item.matData - mean_train_rep) ./ (std_train_rep+1e-8);
                listStruct(i).matDataZScore = i_matDataZScore;
            end

            out = listStruct;
        end
        
            function matDataAll = listStruct2OneMatData(listStruct)
                % 把listStruct的所有场景的matData，生成一个matData
                matDataAll = zeros(1, size(listStruct(1).matData, 2));

                for i = 1 : length(listStruct)
                    item = listStruct(i);
                    matDataAll = vertcat(matDataAll, item.matData);
                end

                matDataAll = matDataAll(2:end, :); % 把第一行去除
            end
        
    end
    
end

