function matData = structArrAll2matData( dataSArr, signalTable )
    % 把 dataSArr中 所有场景 一列列signal数据，转成 整个matData格式。
    matData = zeros(1, length(signalTable.signalName));
    
    for i = 1:length(dataSArr) % 遍历每个场景
        
%          aMatData= [];
%          for j = 1: height(signalTable) % 遍历每个signal
%     %          disp(j);
%              signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
%     %          disp(signalName);
%              a_scenario_signal_data = dataSArr(i).(signalName);
%              aMatData(:, j) = a_scenario_signal_data;
%          end
         
         aMatData = aScenaSignals2matData(dataSArr(i), signalTable);
         matData = vertcat(matData, aMatData);
    end
    matData = matData(2:end, :); % 把第一行去除
end
