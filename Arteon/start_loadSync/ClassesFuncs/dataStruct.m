% ���� ������signal ����txt�ļ�����ԭ�����н���Ԥ������
% ������洢���г������У���Ӧ������signal���У�

function dataStruct()
t0 = clock; % ͳ������ʱ��
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt�д洢
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% ��������Ӧsignal ���ݴ��� dataSArr.mat

dataS = struct; % �洢����kp����
% Ϊ��������ݸ��ã�������ʱstruct
% ֻ�е� ��ǰdir����һ��dir��ͬʱ�������¼���. ��dir��ͬ����û��Ҫ���� �˷�ʱ�䡣
tmp_asignal_val_factor = struct;

for i = 1 : height(scenarioTable) % loop over scenarioTable
    % ��ӦdataSArr ��
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    fprintf('======================\nid: %d\n', id);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); t_begin = t_begin/100; % һ�������µģ�ͬһ����ʱ�俪ʼ
    t_end = scenarioTable.t_end(idx_scenario); t_end = t_end/100; % һ�������µģ�ͬһ����ʱ���ֹ
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).fieldname = fieldname;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    % ��ȡĳһ�� signal��ÿһ����һ������������һ�� mat ����
    % �Աȵ�ǰ�е�dir �Ƿ����һ��һ����һ���Ļ����Ͳ���������load
    if idx_scenario == 1
        ds = load(dir);
    else
        dir_cell_cur = scenarioTable.dir(idx_scenario); dir_cur = dir_cell_cur{1,1};
        dir_cell_pre = scenarioTable.dir(idx_scenario-1); dir_pre = dir_cell_pre{1,1};
        if strcmp(dir_cur, dir_pre) == 0
            dir_flag = 0;
            % ֻ�е� ��ǰdir����һ��dir��ͬʱ����load��% ��dir��ͬ����û��Ҫ��load�˷�ʱ�䡣
            ds = load(dir);
        else
            dir_flag = 1;
        end
    end
    
    for j = 1: height(signalTable) % ��ͬһ��id�£�����signal ʹ��һ���� ʱ����ֹ
        % ��Ӧ dataSArr �У�����Ӧÿһ��signal��ÿ��signal���ڲ�����ͬ��ʱ����ֹ��ͬ����Ҫ�����idx_t
        idx_signal = j;
        signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1}; % kpά�Ⱥ� id����ά�ȶ���
        signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
        signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};
        
        asignal = MySignal(ds, signalSyncName, signalTimeName); % ����ʵ��
        sampling_factor = 10; % ԭʼ����Ƶ����100���²�������10��
        
        try
            % �п���ĳһ��file�����ڣ�������
            % load(), load_filter(), load_extend(), load_filter_extend() �ֳ�����
            % �²��������������ٵ�Ϊ׼��
            % maxLen: 17901, minLen: 1790��10���Ĺ�ϵ������߲���100hz�����10hz 
            
            reuse_flag = 1 ;
            if reuse_flag == 1
                % ʹ��tmpʵ�����ݸ��ã����Լ����1s��Ч�������ԣ���Ϊʹ��tmp��дҲ����ʱ�䡣
                 if idx_scenario == 1
                     % ��һ����������Ҫ���㣬�ҳ�ʼ��tmp��ֵ��
                    [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
                    tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                    tmp_asignal_val_factor.(signalName).factor = factor;
                 else
                    if dir_flag == 1
                        % ��ǰ��������һ������һ��ʱ��ֱ�Ӵ�tmp��ȡ����
                        asignal_alldata = tmp_asignal_val_factor.(signalName).data;
                        factor = tmp_asignal_val_factor.(signalName).factor;
                    else
                        % ��ǰ������ͬ����Ҫ���¼��㣬������tmp��
                        % ����˴�����д tmp������ʱ�䡣�������� �ܶೡ����������һ��matʱ��
                        [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
                        tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                        tmp_asignal_val_factor.(signalName).factor = factor;
                    end
                 end
            else
                % ���ø���
                [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName);
            end
            
            % ���ճ���ʱ�䣬�ҵ�val�� idx��ֹ�ü�.
	    % ������������Ȼ t_begin t_endһ���������ڲ�ͬsignal����Ƶ�ʲ�ͬ��ʹidx�����в�ͬ��
	    % ͨ����ͬsignal��sync_t�ҵ� t_begin��Ӧ��idx_t_begin��������һЩ��� idx_t_end���ɱ�֤signal����׼ȷ
            [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor, sampling_factor);
            asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
            dataS.(fieldname).(signalName) = asignal_clip;
            
        catch
            % ���ĳһ���ļ������ڣ�������һ������ NaN
            asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin) * sampling_factor); % ����10����Ϊ�²����Ĳ���Ƶ���� 10hz
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