% src data (txt files) transform into struct/arr/list ...
function [out_dataS, out_scenarioTable, out_signalTable] = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type)
    % 根据 场景和signal 两个txt文件，对原生进行进行预处理。
    % 输出：存储所有场景（行）对应的所有signal（列）
    % sampling_factor = 100 ; % 原始采样频率是100，下采样后是10，上采样为100hz

    t0 = clock; % 统计运行时间
    %% txt to table
    scenarioTable = importfile_scenario(scenarioFile);
%     fprintf('height(scenarioTable): %d\n', height(scenarioTable));
    signalTable = importfile_signal(signalFile); % txt中存储
    
    out_scenarioTable = scenarioTable;
    out_signalTable = signalTable;

    disp('----------- importfile scenarios and signals,  txt to table over 1/5 ----------------');

    %% 将场景对应signal 数据存在 dataSArr.mat

    dataS = struct; % 存储所有kp数据
    % 为了提高数据复用，采用临时struct
    % 只有当 当前dir和上一个dir不同时，才重新计算. 若dir相同，则没必要再算 浪费时间。
    tmp_asignal_val_factor = struct;

    for i = 1 : height(scenarioTable) % loop over scenarioTable
        % 对应dataSArr 行
        id = scenarioTable.id(i);
        fprintf('======================\nid: %.2f\n', id);
        score = scenarioTable.score(i);
        details_cell = scenarioTable.details(i); details= details_cell{1,1};
        t_begin = scenarioTable.t_begin(i); t_begin = t_begin/100; % 一个场景下的，同一个，时间开始
        t_end = scenarioTable.t_end(i); t_end = t_end/100; % 一个场景下的，同一个，时间截止
        dir_cell = scenarioTable.dir(i); dir = dir_cell{1,1}; % dir包含了 绝对路径下的mat文件
        fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};

        dataS.(fieldname).id = id;
        dataS.(fieldname).fieldname = fieldname;
        dataS.(fieldname).score = score;
        dataS.(fieldname).details = details;

        % 读取某一个 signal，每一行是一个场景，共用一个 mat 数据
        % 对比当前行的dir 是否和上一行一样，一样的话，就不必再重新load
        if i == 1
            ds = load(dir);
        else
            dir_cell_cur = scenarioTable.dir(i); dir_cur = dir_cell_cur{1,1};
            dir_cell_pre = scenarioTable.dir(i-1); dir_pre = dir_cell_pre{1,1};
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

            asignal = MySignal(ds, signalSyncName, signalTimeName, car_type); % 构造实例
            % 需要 signalTimeName，因为需要借助time找到idx

            try
                % 有可能某一个file不存在，若存在
                % load(), load_filter(), load_extend(), load_filter_extend() 分成四种
                % 下采样，以数量最少的为准，
                % maxLen: 17901, minLen: 1790。10倍的关系。即最高采样100hz，最低10hz 

                reuse_flag = 1 ;
                if reuse_flag == 1
                    % 使用tmp实现数据复用，会节约不到1s，效果不明显，因为使用tmp读写也消耗时间。
                     if i == 1
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
                % 若 出现了NaN，则把 try/catch注释，查看原因。应该先确定问题来源。只有当file确实不存在才能用NaN。
                % 如果某一个文件不存在，则令这一列数据 NaN
                asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin) * sampling_factor); % 乘以100，因为Up采样的采样频率是100hz
                asignal_alldata = transpose(asignal_alldata);
                dataS.(fieldname).(signalName) = asignal_alldata;

                fprintf('NaN, fieldname: %s, signalname: %s\n', fieldname, signalName);
            end

        end

    end

    disp('---------------- get dataS over 2/5 ----------------');

    %% Only For Start, 按照 AccePedal = 0，对数据的起始位置idx_ap0 进行 微调
    % 按照 AccePedal 第一个点val为0，而第二个点要 >0
    % 目前有几个场景的FP，在时刻一二都是0.
% 
%     for i = 1 : height(scenarioTable)
%         % 遍历每一个场景
%          fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
%          ap = dataS.(fieldname).AccePedal; % 拿到 AccePedal 这个列向量
% 
%          if ap(1) > 0
%              fprintf('=== Attention! AccePedal(1)>0, please decrease "t_begin" of %s  in test/scenariosOfSyncGeely.txt\n', fieldname);
%              continue
%          end
% 
%          idx_ap0 = 1;
%          for j = 1:length(ap)
%              if ap(j) == 0 && ap(j+1) > 0
%                  idx_ap0 = j;
%                  break;
%              end
%          end
% 
%          fprintf('%s, idx_ap0: %d\n', fieldname ,idx_ap0);
%          if idx_ap0 == 1
%              continue
%          end
% 
%          % 裁剪每个 signal
%          for j = 1: height(signalTable)
%              signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
%              dataS.(fieldname).(signalName) =  dataS.(fieldname).(signalName)(idx_ap0 : end);
%          end
% 
%     end
% 
%     disp('---------------- clip by AccePedal=0 at the begining of Start over 3/5 ----------------');

    %% For All Scenarios (as default), 保证 NaN 的signal数据长度 和其它signal一致
    
    for i = 1 : height(scenarioTable)
         % get length_target
         fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
         es = dataS.(fieldname).EngineSpeed;
         length_target = length(es); % 目标长度

         % 遍历每个场景的每个signal，确保数据为NaN的场景signal长度和其它signal一致
         for j = 1: height(signalTable)
            signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
            signal_data = dataS.(fieldname).(signalName);
            if numel(signal_data)==0 || isnan(signal_data(1))
                % 若是NaN，改造成 长度一致，数值为0
%                 fprintf('fieldname: %s, signalName: %s   is NaN or length(signal_data)=0\n', fieldname, signalName);
                dataS.(fieldname).(signalName) = linspace(0, 0, length_target)';
                
            else
                continue
            end
         end

    end

    disp('---------------- ensure length and val=0 of signal of NaN, over ----------------');

    %% composite TransmInpSpeed for Geely
    % using TransmInpSpeedOdd & TransmInpSpeedEven and CurrentGear
    if strcmp(car_type, 'Geely')
         for i = 1 : height(scenarioTable) % 外层for遍历每一个场景
             fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
             
             for j = 1 : length(dataS.(fieldname).TransmInpSpeed) % 内层for遍历 TransmInpSpeed的每个元素
                 TransmInpSpeedOdd = dataS.(fieldname).TransmInpSpeedOdd(j);
                 TransmInpSpeedEven = dataS.(fieldname).TransmInpSpeedEven(j);
                 CurrentGear = dataS.(fieldname).CurrentGear(j); % 使用 CurrentGear对Odd/Even辨别，来合成
                 
                 is0 = mod(round(CurrentGear), 2); 
                 if is0 == 0 
                     % is even
                    dataS.(fieldname).TransmInpSpeed(j) = TransmInpSpeedEven;
                 else
                     % is odd
                     dataS.(fieldname).TransmInpSpeed(j) = TransmInpSpeedOdd;
                 end  
             end
             
         end
    end
    
    disp('--------------- composite TransmInpSpeed over -----------------');
    
    %% 给所有的场景加入一个 feature：isArteon
    for i = 1 : height(scenarioTable)
        fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
        es = dataS.(fieldname).EngineSpeed;
        length_target = length(es); % 目标长度
         
        dataS.(fieldname).isArteon = linspace(0, 0, length_target)';
        
        if str2num( fieldname(3)) == 1
            % fieldname of Arteon = 'id10xx'
            dataS.(fieldname).isArteon = linspace(1, 1, length_target)';
        end
        
    end
    
    out_dataS = dataS;
    
    
     disp('--------------- add feature: isArteon,  over -----------------');
    
    %% 两种车，都把 TransmInpSpeedOdd/Even and CurrentGear 去掉，同时把 signalTable.mat中 Odd/Even and CurrentGear去掉
    
%     out_dataS = struct;
%     out_scenarioTable = scenarioTable;
%     
%     % out_dataS
%     for i = 1 : height(scenarioTable)
%         fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
% 
%         out_dataS.(fieldname).id = dataS.(fieldname).id;
%         out_dataS.(fieldname).fieldname = dataS.(fieldname).fieldname;
%         out_dataS.(fieldname).score = dataS.(fieldname).score;
%         out_dataS.(fieldname).details = dataS.(fieldname).details;
%          
%         for j = 1: height(signalTable)
%             signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
% 
%             if strcmp(signalName, 'TransmInpSpeedOdd') || strcmp(signalName, 'TransmInpSpeedEven') || strcmp(signalName, 'CurrentGear' )
%                 continue
%             end
%             
%             out_dataS.(fieldname).(signalName) = dataS.(fieldname).(signalName);
%             
%          end
%     end
%     
%     % out_signalTable
%     tmp = []; % 存储要保留的行
%     for j = 1: height(signalTable)
%             signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
%             if strcmp(signalName, 'TransmInpSpeedOdd') || strcmp(signalName, 'TransmInpSpeedEven') || strcmp(signalName, 'CurrentGear')
%                 continue
%             end
%             tmp = [tmp, j];
%     end
%     out_signalTable = signalTable(tmp, :);
% 
%     disp('--------------- remove Odd/Even and CurrentGear of dataS & signalTable   over -----------------');
    
    %% ShiftProcess of Arteon -> ShiftInProgress
    
%     if strcmp(car_type, 'Arteon')
%         
%         for i = 1 : height(scenarioTable)
%              fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
%              old = out_dataS.(fieldname).ShiftInProgress;
%              
%              for j = 1 : length(old)
%                  if old(j) > 0
%                      out_dataS.(fieldname).ShiftInProgress(j) = 1;
%                  else
%                      out_dataS.(fieldname).ShiftInProgress(j) = 0;
%                  end
%              end
%              
%         end
%         
%     end
%     
%     disp('--------------- ShiftProcess -> ShiftInProgress   over -----------------');
    
    %% 
    fprintf('time needed: %.1f s\n', etime(clock, t0));

end
