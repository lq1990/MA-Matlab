function [dataSScaling, dataSArrScaling]=scaling( dataSArr, signalsMaxMinStruct, signalTable )
    dataSScaling = struct;
    
    for si = 1: height(signalTable)
        % 借助 signalTable 取出每个signalName
        signalName_cell = signalTable.signalName(si); signalName = signalName_cell{1,1};
        
        for i = 1: length(dataSArr)
            id = dataSArr(i).id;
            fieldname = dataSArr(i).fieldname;
            score = dataSArr(i).score;
            details = dataSArr(i).details;
            signalVal = dataSArr(i).(signalName);
            maxVal = signalsMaxMinStruct.(signalName).maxVal;
            minVal = signalsMaxMinStruct.(signalName).minVal;
            signalValScaling = (signalVal-minVal)/(maxVal-minVal+1e-8); % scaling

            dataSScaling.(fieldname).id = id;
            dataSScaling.(fieldname).fieldname = fieldname;
            dataSScaling.(fieldname).score = score;
            dataSScaling.(fieldname).details = details;
            dataSScaling.(fieldname).(signalName) = signalValScaling;
        end
        
    end

    dataSArrScaling = struct2array(dataSScaling);
end

