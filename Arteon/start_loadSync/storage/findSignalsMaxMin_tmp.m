function [ mmStruct ] = findSignalsMaxMin_tmp( dataSArr, signalTable)
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
