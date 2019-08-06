function out = aScenaSignals2matData_tmp( aScenario, signalTable )
    % 把 dataSArr中 单个场景 一列列signal数据，转成matData格式。
    
    aMatData= [];
    for j = 1: height(signalTable) % 遍历每个signal
         signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
         a_scenario_signal_data = aScenario.(signalName);
         aMatData(:, j) = a_scenario_signal_data;
    end
     
    out = aMatData;
end
