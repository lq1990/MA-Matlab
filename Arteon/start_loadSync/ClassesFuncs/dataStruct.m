% 根据 场景和signal 两个txt文件，对原生进行进行预处理。
% 输出：存储所有场景（行）对应的所有signal（列）

function dataStruct()
t0 = clock; % 统计运行时间
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt中存储
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% 将场景对应signal 数据存在 dataSArr.mat

dataS = struct; % 存储所有kp数据
% 为了提高数据复用，采用临时struct
% 只有当 当前dir和上一个dir不同时，才重新计算. 若dir相同，则没必要再算 浪费时间。
tmp_asignal_val_factor = struct;

for i = 1 : height(scenarioTable) % loop over scenarioTable
    % 对应dataSArr 行
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    fprintf('======================\nid: %d\n', id);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); t_begin = t_begin/100; % 一个场景下的，同一个，时间开始
    t_end = scenarioTable.t_end(idx_scenario); t_end = t_end/100; % 一个场景下的，同一个，时间截止
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).fieldname = fieldname;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    % 读取某一个 signal，每一行是一个场景，共用一个 mat 数据
    % 对比当前行的dir 是否和上一行一样，一样的话，就不必再重新load
    if idx_scenario == 1
        ds = load(dir);
    else
        dir_cell_cur = scenarioTable.dir(idx_scenario); dir_cur = dir_cell_cur{1,1};
        dir_cell_pre = scenarioTable.dir(idx_scenario-1); dir_pre = dir_cell_pre{1,1};
        if strcmp(dir_cur, dir_pre) == 0
            dir_flag = 0;
            % 只有当 当前dir和上一个dir不同时，才load。% 若dir相同，则没必要再load浪费时间。
            ds = load(dir);
        else
            dir_flag = 1;
        end
    end
    
    for j = 1: height(signalTable) % 在同一个id下，所有signal 使用一样的 时间起止
        % 对应 dataSArr 列，即对应每一个signal。每个signal由于采样不同，时间起止不同。需要计算出idx_t
        idx_signal = j;
        signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1}; % kp维度和 id场景维度独立
        signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
        signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};
        
        asignal = MySignal(ds, signalSyncName, signalTimeName); % 构造实例
        sampling_factor = 10; % 原始采样频率是100，下采样后是10。
        
        try
            % 有可能某一个file不存在，若存在
            % load(), load_filter(), load_extend(), load_filter_extend() 分成四种
            % 下采样，以数量最少的为准，
            % maxLen: 17901, minLen: 1790。10倍的关系。即最高采样100hz，最低10hz 
            
            reuse_flag = 1 ;
            if reuse_flag == 1
                % 使用tmp实现数据复用，会节约不到1s，效果不明显，因为使用tmp读写也消耗时间。
                 if idx_scenario == 1
                     % 第一个场景必须要计算，且初始化tmp数值。
                    [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
                    tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                    tmp_asignal_val_factor.(signalName).factor = factor;
                 else
                    if dir_flag == 1
                        % 当前场景和上一个场景一样时，直接从tmp中取数据
                        asignal_alldata = tmp_asignal_val_factor.(signalName).data;
                        factor = tmp_asignal_val_factor.(signalName).factor;
                    else
                        % 当前场景不同，需要重新计算，并更新tmp。
                        % 正因此处的重写 tmp，消耗时间。尤其是在 很多场景都不公用一个mat时。
                        [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
                        tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                        tmp_asignal_val_factor.(signalName).factor = factor;
                    end
                 end
            else
                % 不用复用
                [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
            end
            
            % 按照场景时间，找到val中 idx起止裁剪
            [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor, sampling_factor);
            asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
            dataS.(fieldname).(signalName) = asignal_clip;
            
        catch
            % 如果某一个文件不存在，则令这一列数据 NaN
            asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin) * sampling_factor); % 乘以10，因为下采样的采样频率是 10hz
            asignal_alldata = transpose(asignal_alldata);
            dataS.(fieldname).(signalName) = asignal_alldata;

            fprintf('NaN, fieldname: %s, kpname: %s\n', fieldname, signalName);
        end
        
    end
    
end

disp('---------------- loop over 2/3 ----------------');

%%
dataSArr = struct2array(dataS);

save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

disp('--------------- save over 3/3 -----------------');

fprintf('time needed: %d s\n', etime(clock, t0));
end