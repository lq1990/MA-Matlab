function matData = structArrAll2matData_tmp( dataSArr, signalTable )
    % �� dataSArr�� ���г��� һ����signal���ݣ�ת�� ����matData��ʽ��
    matData = zeros(1, length(signalTable.signalName));
    
    for i = 1:length(dataSArr) % ����ÿ������
         aMatData = aScenaSignals2matData(dataSArr(i), signalTable);
         matData = vertcat(matData, aMatData);
    end
    matData = matData(2:end, :); % �ѵ�һ��ȥ��
end
