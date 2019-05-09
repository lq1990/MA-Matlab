function out = aScenaSignals2matData_tmp( aScenario, signalTable )
    % �� dataSArr�� �������� һ����signal���ݣ�ת��matData��ʽ��
    
    aMatData= [];
    for j = 1: height(signalTable) % ����ÿ��signal
         signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
         a_scenario_signal_data = aScenario.(signalName);
         aMatData(:, j) = a_scenario_signal_data;
    end
     
    out = aMatData;
end
