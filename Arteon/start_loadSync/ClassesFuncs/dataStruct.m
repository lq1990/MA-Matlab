function dataS = dataStruct()
    % ������ signal���ڲ���� ����
    % Ŀ�ģ��� dir_cur dir_pre ��ͬ���򷽱�ʵ�� signal���ݿɸ���
    
    % ���⣺����� signal��û�л�һ��signal��Ҫ ����load���ݣ������

t0 = clock; % ͳ������ʱ��
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt�д洢
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');

%% ��������Ӧsignal ���ݴ��� dataSArr.mat

dataS = struct; % ��ʼ��һ�� struct�������洢����

for i = 1 : height(signalTable)
    idx_signal = i;
    signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1};
    signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
    signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};
    fprintf('======================\nsignalName: %s\n', signalName);
    
        
    for j = 1: height(scenarioTable)
        idx_scenario = j;
        id = scenarioTable.id(idx_scenario);
        score = scenarioTable.score(idx_scenario);
        details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
        t_begin = scenarioTable.t_begin(idx_scenario); t_begin = t_begin/100; % һ�������µģ�ͬһ����ʱ�俪ʼ
        t_end = scenarioTable.t_end(idx_scenario); t_end = t_end/100;% һ�������µģ�ͬһ����ʱ���ֹ
        dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
        fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataS.(fieldname).id = id;
        dataS.(fieldname).fieldname = fieldname;
        dataS.(fieldname).score = score;
        dataS.(fieldname).details = details;
        
        
        ds = load(dir);
        asignal = MySignal(ds, signalSyncName, signalTimeName); % ����ʵ��
        samplingFactor = 10; % ԭʼ����Ƶ����100���²�������10��
        
        % ��ÿ��signal����ֵд��
        dataS.(fieldname).(signalName) = signalName;
        
    end
    
end

disp('---------------- loop over 2/3 ----------------');

%%
% dataSArr = struct2array(dataS);
% 
% save '.\DataFinalSave\dataS' dataS
% save '.\DataFinalSave\dataSArr' dataSArr
% 
% disp('--------------- save over 3/3 -----------------');
% 
% fprintf('time needed: %d s\n', etime(clock, t0));

end
