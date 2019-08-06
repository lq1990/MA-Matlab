classdef MyListStruct
    % �й� listStruct  �Ĳ���
    % listStruct: [{id, score, details, matData, ... },{...},...]
    % ��list���棬����ȡֵ������ ��
    
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
                % ��listStruct�����г�����matData������һ��matData
                matDataAll = zeros(1, size(listStruct(1).matData, 2));

                for i = 1 : length(listStruct)
                    item = listStruct(i);
                    matDataAll = vertcat(matDataAll, item.matData);
                end

                matDataAll = matDataAll(2:end, :); % �ѵ�һ��ȥ��
            end
        
    end
    
end

