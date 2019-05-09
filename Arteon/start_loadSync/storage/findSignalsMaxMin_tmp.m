function [ mmStruct ] = findSignalsMaxMin_tmp( dataSArr, signalTable)
% 找到每个signal在所有场景下的 max，min。为了后续 scaling
    mmS = struct;
    for i = 1:height(signalTable)
        % 借助 signalTable 拿到 signalName，方便操作 dataSArr
        signalName_cell = signalTable.signalName(i);
        signalName = signalName_cell{1,1};
        
        maxValList = [];
        minValList = [];
        for j = 1: length(dataSArr)
            sVal = dataSArr(j).(signalName);
            maxSVal = max(sVal); % 计算第 j 行场景对应signal的 max
            minSVal = min(sVal);
            
            maxValList = [maxValList, maxSVal]; % 将所有场景对应signal的max存到list
            minValList = [minValList, minSVal];
        end
        
        mmS.(signalName).signalName = signalName;
        mmS.(signalName).maxVal = max(maxValList); % 取list 全局最大
        mmS.(signalName).minVal = min(minValList);
        
    end

    mmStruct = mmS;
        % 注：应考虑到 max与min相等的情况，
        % 比如在数据中  CurrentGear的max与min相等。使得计算结果为NaN
        % 当然在这种情况下，说明 此signal没有必要使用了。
end
