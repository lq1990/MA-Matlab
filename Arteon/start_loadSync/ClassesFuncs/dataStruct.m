% ���� ������signal ����txt�ļ�����ԭ�����н���Ԥ����
% ������洢���г������У���Ӧ������signal���У�

% ���fn�ᱻ�������Σ�
% ��һ�Σ�û��nargin�����ݱ����ˣ��²��������ճ���ʱ����clip
% �ڶ��Σ�����nargin����signal�����Сֵ���ڵ�һ�λ������� ��һ��
function dataStruct(signalsMaxMinStruct)
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt�д洢
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% ��������Ӧkp ���ݴ��� dataSArr.mat

% ȡ�� ����id17���������˵�Ԥ������AccPedal��������������
dataS = struct; % �洢����kp����

for i = 1 : height(scenarioTable) % loop over scenarioTable
    % ��ӦdataSArr ��
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    fprintf('======================\nid: %d\n', id);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % һ�������µģ�ͬһ����ʱ�俪ʼ
    t_begin = t_begin/100;
    t_end = scenarioTable.t_end(idx_scenario); % һ�������µģ�ͬһ����ʱ���ֹ
    t_end = t_end/100;
    % idx_t_begin; % �ҵ���Ӧtime��idx
    % idx_t_end;
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    % ��ȡĳһ�� signal��ÿһ����һ������������һ�� mat ����
    ds = load(dir);
    
    for j = 1: height(signalTable) % ��ͬһ��id�£�����signal ʹ��һ���� ʱ����ֹ
        % ��Ӧ dataSArr �У�����Ӧÿһ��signal��ÿ��signal���ڲ�����ͬ��ʱ����ֹ��ͬ����Ҫ�����idx_t
        idx_signal = j;
        signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1}; % kpά�Ⱥ� id����ά�ȶ���
        signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
        signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};
        
        asignal = MySignal(ds, signalSyncName, signalTimeName); % ����ʵ��
        try
            % �п���ĳһ��file�����ڣ�������
            % load(), load_filter(), load_extend(), load_filter_extend() �ֳ�����
            % �²��������������ٵ�Ϊ׼��
            % maxLen: 17901, minLen: 1790��10���Ĺ�ϵ������߲���100hz�����10hz
            if strcmp(signalName, 'EngineSpeed') % length: 17901
                factor = 1/10; % factor < 1���²��� 
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

            % ���ճ���ʱ����ֹ�ü�
            asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
            % scaling
             if nargin == 1
                 % ���nargin�� signalsMaxMinStruct
                maxVal= signalsMaxMinStruct.(signalName).maxVal; 
                minVal= signalsMaxMinStruct.(signalName).minVal;
                asignal_clip_scaling = (asignal_clip-minVal)/(maxVal-minVal); % scaling 0-1
                dataS.(fieldname).(signalName) = asignal_clip_scaling;
                
             else 
                 dataS.(fieldname).(signalName) = asignal_clip;
            end
            
        catch
            % ���ĳһ���ļ������ڣ�������һ������ NaN
            asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin)*10); % ����10����Ϊ�²����Ĳ���Ƶ���� 10hz
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