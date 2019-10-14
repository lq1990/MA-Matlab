function [ asignal_alldata, factor ]= tryASignalAllData(asignal, signalName, sampling_factor )
    
    if strcmp(signalName, 'EngineSpeed') 
        % 考虑到有些场景比如前三个，是同一个场景，只不过截取的t不同。为了加速，可以少计算============
        if strcmp(asignal.m_car_type, 'Arteon') % length: 17901
            factor = sampling_factor / 100 * 1; % factor < 1是下采样，factor > 1 上采样
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        else
            disp('car type is wrong. only ''Arteon'' or ''Geely'' is allowed! ');
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'VehicleSpeed') 
        if strcmp(asignal.m_car_type, 'Arteon') % 8951
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor); 
    elseif strcmp(signalName, 'LongAcce') 
        if strcmp(asignal.m_car_type, 'Arteon')% 8952
            factor = sampling_factor / 100 * 2;   
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1; 
        end
        asignal_alldata = asignal.load_filter_extend(15, factor); % filter
    elseif strcmp(signalName, 'LateralAcce') % 8952
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_filter_extend(15, factor); % filter
    elseif strcmp(signalName, 'AccePedal') % 8951
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'ThrottlePos') % 1791
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 10;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'KickDown') % 1855
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 10;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'EngineTorque') % 17901
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_filter_extend(15, factor); % filter
    elseif strcmp(signalName, 'TransmInpSpeed') % 8954
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'TransmInpSpeedOdd') % 8954
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1; % Arteon没有odd，所以直接设置facotor为  *1
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'TransmInpSpeedEven') % 8954
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'CurrentGear') % 8953
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'DrivingProgram') % 1790
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 10;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 5;
        end
        asignal_alldata = asignal.load_extend(factor);
    
    elseif strcmp(signalName, 'TargetGear') % 3581
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 5;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'EngineIntervention')
        if strcmp(asignal.m_car_type, 'Arteon') % 3581
            factor = sampling_factor / 100 * 5;
        elseif strcmp(asignal.m_car_type, 'Geely') % 
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_filter_extend(15, factor); % filter
        
    elseif strcmp(signalName, 'ShiftProcess') % 
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 5;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
        
    elseif strcmp(signalName, 'ShiftInProgress') % 3581
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'BrakePressure') % 8952
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 2;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'SteerWheelAngle') % 17903
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'SteerWheelSpeed') % 17903
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 1;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    elseif strcmp(signalName, 'AccStatus') % 8952
        if strcmp(asignal.m_car_type, 'Arteon')
            factor = sampling_factor / 100 * 2;
        elseif strcmp(asignal.m_car_type, 'Geely')
            factor = sampling_factor / 100 * 1;
        end
        asignal_alldata = asignal.load_extend(factor);
    else
        disp('                      --- invalid signalName ---');
    end    


end

