classdef MyNormalization
    % my normalization
        % min-max scaling
        % Z-score standardization
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function [dataSScaling, dataSArrScaling]=minMaxScaling( dataSArr, signalsMaxMinStruct, signalTable )
        % dataSArr: min-max scaling to normalize dataSArr
        % signalsMaxMinStruct: provides min-max values of signals of training data
        % signalTable: signal list to help us to find signals in dataSArr
      
            dataSScaling = struct;

            for si = 1: height(signalTable)
                % ���� signalTable ȡ��ÿ��signalName
                signalName_cell = signalTable.signalName(si); signalName = signalName_cell{1,1};

                for i = 1: length(dataSArr)
                    id = dataSArr(i).id;
                    fieldname = dataSArr(i).fieldname;
                    score = dataSArr(i).score;
                    details = dataSArr(i).details;
                    signalVal = dataSArr(i).(signalName);
                    maxVal = signalsMaxMinStruct.(signalName).maxVal;
                    minVal = signalsMaxMinStruct.(signalName).minVal;
                    signalValScaling = (signalVal-minVal)/(maxVal-minVal+1e-8); % scaling

                    dataSScaling.(fieldname).id = id;
                    dataSScaling.(fieldname).fieldname = fieldname;
                    dataSScaling.(fieldname).score = score;
                    dataSScaling.(fieldname).details = details;
                    dataSScaling.(fieldname).(signalName) = signalValScaling;
                end

            end

            dataSArrScaling = struct2array(dataSScaling);
        end

        function [ mmStruct ] = findSignalsMaxMin( dataSArr, signalTable)
        % �ҵ�ÿ��signal�����г����µ� max��min��Ϊ�˺��� scaling
            mmS = struct;
            for i = 1:height(signalTable)
                % ���� signalTable �õ� signalName��������� dataSArr
                signalName_cell = signalTable.signalName(i);
                signalName = signalName_cell{1,1};

                maxValList = [];
                minValList = [];
                for j = 1: length(dataSArr)
                    sVal = dataSArr(j).(signalName);
                    maxSVal = max(sVal); % ����� j �г�����Ӧsignal�� max
                    minSVal = min(sVal);

                    maxValList = [maxValList, maxSVal]; % �����г�����Ӧsignal��max�浽list
                    minValList = [minValList, minSVal];
                end

                mmS.(signalName).signalName = signalName;
                mmS.(signalName).maxVal = max(maxValList); % ȡlist ȫ�����
                mmS.(signalName).minVal = min(minValList);

            end

            mmStruct = mmS;
                % ע��Ӧ���ǵ� max��min��ȵ������
                % ������������  CurrentGear��max��min��ȡ�ʹ�ü�����ΪNaN
                % ��Ȼ����������£�˵�� ��signalû�б�Ҫʹ���ˡ�
        end

    end
    
end

