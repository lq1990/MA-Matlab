% 根据 场景和signal 两个txt文件，对原生进行进行预处理。
% 输出：存储所有场景（行）对应的所有signal（列）

function dataStruct(sampling_factor)
%         sampling_factor = 100 ; % 原始采样频率是100，下采样后是10，上采样为100hz

t0 = clock; % 统计运行时间

%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt中存储
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/4 ----------------');

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
    
    % 每一个场景，都找 idx_v30，取min(idx_v30, idx_t_end) 作为真正的 idx_t_end
    % 为了理解和操作方便，在本文件的后面操作
    
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
            
            reuse_flag = 1 ;
            if reuse_flag == 1
                % 使用tmp实现数据复用，会节约不到1s，效果不明显，因为使用tmp读写也消耗时间。
                 if idx_scenario == 1
                     % 第一个场景必须要计算，且初始化tmp数值。
                    [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor);
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
                        [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor); % 数据被extend，filter
                        tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                        tmp_asignal_val_factor.(signalName).factor = factor;
                    end
                 end
            else
                % 不用复用
                [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor);
            end
            
            % 按照场景时间，找到val中 idx起止裁剪.
	    % 单个场景中虽然 t_begin t_end一样，但由于不同signal采样频率不同，使idx就略有不同。
	    % 通过不同signal的sync_t找到 t_begin对应的idx_t_begin，往后延一些算出 idx_t_end。可保证signal数据准确
            [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor, sampling_factor);
            
%             disp(signalName);
%             fprintf('length(asignal_alldata): %d \n',length(asignal_alldata));
%             fprintf('idx_t_begin: %d \n',idx_t_begin);
%             fprintf('idx_t_end: %d \n',idx_t_end);
            
            asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
            dataS.(fieldname).(signalName) = asignal_clip;

        catch
            % 若 出现了NaN，则把 try/catch注释，查看原因。
            % 如果某一个文件不存在，则令这一列数据 NaN
            asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin) * sampling_factor); % 乘以10，因为下采样的采样频率是 10hz
            asignal_alldata = transpose(asignal_alldata);
            dataS.(fieldname).(signalName) = asignal_alldata;

            fprintf('NaN, fieldname: %s, kpname: %s\n', fieldname, signalName);
        end
        
    end
    
end

disp('---------------- loop over 2/4 ----------------');

%% 按照 AccePedal = 0，对数据进行 微调
% 按照 AccePedal 第一个点val为0，而第二个点要 >0
% 目前有几个场景的FP，在时刻一二都是0.






%% 按照 v= 30 km/h 为限 对 dataS 进行裁剪，因为汽车起步 30km/h，再大的速度就不是起步过程了
for i = 1 : height(scenarioTable)
    % 遍历每一个场景，找到每个场景中 idx_v30
     fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
     vs = dataS.(fieldname).VehicleSpeed;
     
     % 若某个场景的车速 不超过30，直接continue
     if max(vs) <= 30
         fprintf('===%s continue\n', fieldname);
         continue
     end
    
     % 此时必然存在 VehicleSpeed > 30, 寻找 idx_v30，逐步加大 阈值
     % 或 考虑到汽车起步速度是不断增的，可倒过来遍历 vs，找到比30小的最近的idx
     for i_vs = length(vs):-1:1
         if vs(i_vs) > 30
             continue
         end
         idx_v30 = i_vs;
         break
     end
%      marg = 0.05;
%      while isempty(find( (30-vs) <marg, 1))
%          marg = marg+ 0.05;
%      end
%      idx_v30 = find( abs(vs-30) < marg, 1); 
%      
%      if vs(idx_v30) > 30
%          idx_v30 = idx_v30 -1;
%      end

     fprintf('%s, idx_v30: %d\n', fieldname ,idx_v30);
     
     % 裁剪每个 signal
     for j = 1: height(signalTable)
         signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
         dataS.(fieldname).(signalName) =  dataS.(fieldname).(signalName)(1:idx_v30); % 以 idx_v30为界限
     end
    
end

disp('---------------- clip by idx_v30 over 3/4 ----------------');

%%
dataSArr = struct2array(dataS);

save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

disp('--------------- save over 4/4 -----------------');

fprintf('time needed: %d s\n', etime(clock, t0));

end
