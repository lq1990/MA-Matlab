function matData = structArrAll2matData( dataSArr, signalTable )
    % �� dataSArr�� ���г��� һ����signal���ݣ�ת�� ����matData��ʽ��
    matData = zeros(1, length(signalTable.signalName));
    
    for i = 1:length(dataSArr) % ����ÿ������
        
%          aMatData= [];
%          for j = 1: height(signalTable) % ����ÿ��signal
%     %          disp(j);
%              signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
%     %          disp(signalName);
%              a_scenario_signal_data = dataSArr(i).(signalName);
%              aMatData(:, j) = a_scenario_signal_data;
%          end
         
         aMatData = aScenaSignals2matData(dataSArr(i), signalTable);
         matData = vertcat(matData, aMatData);
    end
    matData = matData(2:end, :); % �ѵ�һ��ȥ��
end
