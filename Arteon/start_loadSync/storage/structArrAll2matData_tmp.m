function matData = structArrAll2matData_tmp( dataSArr, signalTable )
    % 把 dataSArr中 所有场景 一列列signal数据，转成 整个matData格式。
    matData = zeros(1, length(signalTable.signalName));
    
    for i = 1:length(dataSArr) % 遍历每个场景
         aMatData = aScenaSignals2matData(dataSArr(i), signalTable);
         matData = vertcat(matData, aMatData);
    end
    matData = matData(2:end, :); % 把第一行去除
end
