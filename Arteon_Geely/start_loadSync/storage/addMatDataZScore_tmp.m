function out = addMatDataZScore( listStruct, meanVec, stdVec )
    % for listStructTrain and listStructTest

    for i = 1 : length(listStruct)

        item = listStruct(i);
        mean_train_rep = repmat(meanVec, length(item.matData),1);
        std_train_rep = repmat(stdVec, length(item.matData),1);

        i_matDataZScore = (item.matData - mean_train_rep) ./ (std_train_rep+1e-8);
        listStruct(i).matDataZScore = i_matDataZScore;
    end
    
    out = listStruct;

end

