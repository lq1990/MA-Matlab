classdef MyFeatureEng
    % Feature Engineering
    % contains:
    %     1. normalization
    %           min-max scaling
    %           Z-score standardization
    %     2. PCA
    %     3. Upsampling/Downsampling  -> MyExtend
    %     4. Filtering                                -> MyFilter
    
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
        
        function  [ev, lambda, data_mean, data_std]=PCA_Show(allMatData, carStr)
            data_mean = mean(allMatData);
            data_std = std(allMatData);
            data_mean_rep = repmat(mean(allMatData), length(allMatData),1 );
            data_std_rep = repmat(std(allMatData), length(allMatData),1 );

            % Z-score Standardization
            allMatDataNorm = (allMatData - data_mean_rep) ./ (data_std_rep+1e-8); % avoid num/0

            % covariance, over cols
            cov_data = cov(allMatDataNorm); % equivalent to Correlation Coefficient because of normaliation

            % figure;
            % showMatrix('var', var_data, 0);
            figure;
            MyPlot.showMatrix('cov', cov_data, 0, carStr);

            [ev, lambda] = eig(cov_data); % ev����������, ev*ev'=E�� ev ÿ�ж��ǵ�λ������������֮������

            figure;
            MyPlot.showMatrix('lambda', lambda, 0, carStr);

            figure;
            MyPlot.showMatrix('eigenvector', ev, 0, carStr);
        end
    end
    
end

