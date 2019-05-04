function [ asignal_alldata, factor ]= tryASignalAllData(asignal, signalName, sampling_factor )
    
    if strcmp(signalName, 'EngineSpeed') % length: 17901
        % 考虑到有些场景比如前三个，是同一个场景，只不过截取的t不同。为了加速，可以少计算============
%         factor = 10* 1/10; 
        factor = sampling_factor / 100 * 1; % factor < 1是下采样，factor > 1 上采样
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'VehicleSpeed') % 8951
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor); 
    elseif strcmp(signalName, 'LongAcce') % 8952
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor); 
    elseif strcmp(signalName, 'LateralAcce') % 8952
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_filter_extend(15, factor); 
    elseif strcmp(signalName, 'AccePedal') % 8951
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'ThrottlePos') % 1791
%         factor = 10* 1;
        factor = sampling_factor / 100 * 10;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'KickDown') % 1855
%         factor = 10* 1;
        factor = sampling_factor / 100 * 10;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'EngineTorque') % 17901
%         factor = 10* 1/10;
        factor = sampling_factor / 100 * 1;
        asignal_alldata = asignal.load_filter_extend(15, factor);
    elseif strcmp(signalName, 'TransmInpSpeed') % 8954
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'DrivingProgram') % 1790
%         factor = 10* 1;
        factor = sampling_factor / 100 * 10;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'CurrentGear') % 8953
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'TargetGear') % 3581
%         factor = 10* 1/2;
        factor = sampling_factor / 100 * 5;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'ShiftProcess') % 3581
%         factor = 10* 1/2;
        factor = sampling_factor / 100 * 5;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'BrakePressure') % 8952
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'SteerWheelAngle') % 17903
%         factor = 10* 1/10;
        factor = sampling_factor / 100 * 1;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'SteerWheelSpeed') % 17903
%         factor = 10* 1/10;
        factor = sampling_factor / 100 * 1;
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'AccStatus') % 8952
%         factor = 10* 1/5;
        factor = sampling_factor / 100 * 2;
        asignal_alldata = asignal.load_extend(factor);
    end    


end

