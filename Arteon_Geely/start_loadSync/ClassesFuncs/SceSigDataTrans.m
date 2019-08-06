classdef SceSigDataTrans
    % Scenarios Signals Data Transform
    
    properties
    end
    
    methods
        
    end
    
    
    methods(Static)
        function outList = allSce2ListStruct( dataSArr, signalTable )
            % struct {id, score, matData} => [struct1, struct2, ...]
            % listStruct stores info of all scenarios.
            % each element i.e. struct in listStruct represents one scenario
            list = [];
            for i = 1:length(dataSArr) % 遍历每个场景
                s = struct; % 每个场景都有一个struct存储id score matData

                s.id = dataSArr(i).id;
                s.score = dataSArr(i).score;
                s.details = dataSArr(i).details;
                s.matData = SceSigDataTrans.aScenaSignals2matData(dataSArr(i), signalTable);

                list = [list, s];
            end

            outList = list;
        end
        
        function matData = structArrAll2matData( dataSArr, signalTable )
            % 把 dataSArr中 所有场景 一列列signal数据，转成 整个matData格式。
            matData = zeros(1, length(signalTable.signalName));

            for i = 1:length(dataSArr) % 遍历每个场景
                 aMatData = SceSigDataTrans.aScenaSignals2matData(dataSArr(i), signalTable);
                 matData = vertcat(matData, aMatData);
            end
            matData = matData(2:end, :); % 把第一行去除
        end

        function out = aScenaSignals2matData( aScenario, signalTable )
            % 把 dataSArr中 单个场景 一列列signal数据，转成matData格式。

            aMatData= [];
            for j = 1: height(signalTable) % 遍历每个signal
                 signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
                 a_scenario_signal_data = aScenario.(signalName);
                 aMatData(:, j) = a_scenario_signal_data;
            end

            out = aMatData;
        end


        
    end
    
end

