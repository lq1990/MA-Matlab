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
            for i = 1:length(dataSArr) % ����ÿ������
                s = struct; % ÿ����������һ��struct�洢id score matData

                s.id = dataSArr(i).id;
                s.score = dataSArr(i).score;
                s.details = dataSArr(i).details;
                s.matData = SceSigDataTrans.aScenaSignals2matData(dataSArr(i), signalTable);

                list = [list, s];
            end

            outList = list;
        end
        
        function matData = structArrAll2matData( dataSArr, signalTable )
            % �� dataSArr�� ���г��� һ����signal���ݣ�ת�� ����matData��ʽ��
            matData = zeros(1, length(signalTable.signalName));

            for i = 1:length(dataSArr) % ����ÿ������
                 aMatData = SceSigDataTrans.aScenaSignals2matData(dataSArr(i), signalTable);
                 matData = vertcat(matData, aMatData);
            end
            matData = matData(2:end, :); % �ѵ�һ��ȥ��
        end

        function out = aScenaSignals2matData( aScenario, signalTable )
            % �� dataSArr�� �������� һ����signal���ݣ�ת��matData��ʽ��

            aMatData= [];
            for j = 1: height(signalTable) % ����ÿ��signal
                 signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
                 a_scenario_signal_data = aScenario.(signalName);
                 aMatData(:, j) = a_scenario_signal_data;
            end

            out = aMatData;
        end


        
    end
    
end

