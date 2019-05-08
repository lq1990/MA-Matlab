function outList = allSce2ListStruct( dataSArr, signalTable )
    % struct {id, score, matData} => [struct1, struct2, ...]

    list = [];
    
    for i = 1:length(dataSArr) % ����ÿ������
        s = struct; % ÿ����������һ��struct�洢id score matData
        
        s.id = dataSArr(i).id;
        s.score = dataSArr(i).score;
        s.matData = aScenaSignals2matData(dataSArr(i), signalTable);
        
        list = [list, s];
    end

    outList = list;
end

