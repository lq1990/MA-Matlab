% 根据 场景和signal 两个txt文件，对原生进行进行预处理。
% 输出：存储所有场景（行）对应的所有signal（列）

% 这个fn会被运行两次，
% 第一次：没有nargin，数据被过滤，下采样，按照场景时间做clip
% 第二次：有了nargin关于signal最大最小值，在第一次基础上做 归一化
function dataStruct(signalsMaxMinStruct)
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt中存储
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% 将场景对应kp 数据存在 dataSArr.mat

% 取出 场景id17，经过过滤等预处理后的AccPedal。共给场景类用
dataS = struct; % 存储所有kp数据

for i = 1 : height(scenarioTable) % loop over scenarioTable
    % 对应dataSArr 行
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    fprintf('======================\nid: %d\n', id);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % 一个场景下的，同一个，时间开始
    t_begin = t_begin/100;
    t_end = scenarioTable.t_end(idx_scenario); % 一个场景下的，同一个，时间截止
    t_end = t_end/100;
    % idx_t_begin; % 找到对应time的idx
    % idx_t_end;
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    % 读取某一个 signal，每一行是一个场景，共用一个 mat 数据
    ds = load(dir);
    
    for j = 1: height(signalTable) % 在同一个id下，所有signal 使用一样的 时间起止
        % 对应 dataSArr 列，即对应每一个signal。每个signal由于采样不同，时间起止不同。需要计算出idx_t
        idx_signal = j;
        signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1}; % kp维度和 id场景维度独立
        signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
        signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};
        
        asignal = MySignal(ds, signalSyncName, signalTimeName); % 构造实例
        try
            % 有可能某一个file不存在，若存在
            % load(), load_filter(), load_extend(), load_filter_extend() 分成四种
            % 下采样，以数量最少的为准，
            % maxLen: 17901, minLen: 1790。10倍的关系。即最高采样100hz，最低10hz
            if strcmp(signalName, 'EngineSpeed') % length: 17901
                factor = 1/10; % factor < 1是下采样 
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
               
            elseif strcmp(signalName, 'VehicleSpeed') % 8951
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor); 
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'LongAcce') % 8952
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor); 
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'LateralAcce') % 8952
                factor = 1/5;
                asignal_alldata = asignal.load_filter_extend(13, factor); 
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'AccePedal') % 8951
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'ThrottlePos') % 1791
                factor = 1;
                asignal_alldata = asignal.load();
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'KickDown') % 1855
                factor = 1;
                asignal_alldata = asignal.load();
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'EngineTorque') % 17901
                factor = 1/10;
                asignal_alldata = asignal.load_filter_extend(13, factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'TransmInpSpeed') % 8954
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'DrivingProgram') % 1790
                factor = 1;
                asignal_alldata = asignal.load();
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'CurrentGear') % 8953
                factor = 1/5;
                asignal_alldata = asignal.load_extend(1/5);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'TargetGear') % 3581
                factor = 1/2;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'ShiftProgress') % 3581
                factor = 1/2;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'BrakePressure') % 8952
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'SteerWheelAngle') % 17903
                factor = 1/10;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'SteerWheelSpeed') % 17903
                factor = 1/10;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            elseif strcmp(signalName, 'AccStatus') % 8952
                factor = 1/5;
                asignal_alldata = asignal.load_extend(factor);
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor);
            end

            % 按照场景时间起止裁剪
            asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
            % scaling
             if nargin == 1
                 % 如果nargin给 signalsMaxMinStruct
                maxVal= signalsMaxMinStruct.(signalName).maxVal; 
                minVal= signalsMaxMinStruct.(signalName).minVal;
                asignal_clip_scaling = (asignal_clip-minVal)/(maxVal-minVal); % scaling 0-1
                dataS.(fieldname).(signalName) = asignal_clip_scaling;
                
             else 
                 dataS.(fieldname).(signalName) = asignal_clip;
            end
            
        catch
            % 如果某一个文件不存在，则令这一列数据 NaN
            asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin)*10); % 乘以10，因为下采样的采样频率是 10hz
            asignal_alldata = transpose(asignal_alldata);
            dataS.(fieldname).(signalName) = asignal_alldata;

            fprintf('NaN, fieldname: %s, kpname: %s\n', fieldname, signalName);
        end
        
    end
    
end

disp('---------------- loop over 2/3 ----------------');

%%
dataSArr = struct2array(dataS);
if nargin==1
    dataSScaling = dataS;
    dataSArrScaling = dataSArr;
    save '.\DataFinalSave\dataSScaling' dataSScaling
    save '.\DataFinalSave\dataSArrScaling' dataSArrScaling
else
    save '.\DataFinalSave\dataS' dataS
    save '.\DataFinalSave\dataSArr' dataSArr
end

disp('--------------- save over 3/3 -----------------');

end