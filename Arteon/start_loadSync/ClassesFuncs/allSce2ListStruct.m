function outList = allSce2ListStruct( dataSArr, signalTable )
    % struct {id, score, matData} => [struct1, struct2, ...]

    list = [];
    
    for i = 1:length(dataSArr) % 遍历每个场景
        s = struct; % 每个场景都有一个struct存储id score matData
        
        s.id = dataSArr(i).id;
        s.score = dataSArr(i).score;
        s.matData = aScenaSignals2matData(dataSArr(i), signalTable);
        
        list = [list, s];
    end

    outList = list;
end

