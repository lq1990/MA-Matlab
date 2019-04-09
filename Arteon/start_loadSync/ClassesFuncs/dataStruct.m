function dataS = dataStruct()
    % 外层遍历 signal，内层遍历 场景
    % 目的：若 dir_cur dir_pre 相同，则方便实现 signal数据可复用
    
    % 难题：外层是 signal，没切换一个signal都要 重新load数据，会很慢

t0 = clock; % 统计运行时间
%% txt to table
scenarioTable = importfile_scenario('scenariosOfSync.txt');
signalTable = importfile_signal('signalsOfSync.txt'); % txt中存储
save '.\src\signalTable' signalTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');

%% 将场景对应signal 数据存在 dataSArr.mat

dataS = struct; % 初始化一个 struct，用来存储数据

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
        t_begin = scenarioTable.t_begin(idx_scenario); t_begin = t_begin/100; % 一个场景下的，同一个，时间开始
        t_end = scenarioTable.t_end(idx_scenario); t_end = t_end/100;% 一个场景下的，同一个，时间截止
        dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
        fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
        
        dataS.(fieldname).id = id;
        dataS.(fieldname).fieldname = fieldname;
        dataS.(fieldname).score = score;
        dataS.(fieldname).details = details;
        
        
        ds = load(dir);
        asignal = MySignal(ds, signalSyncName, signalTimeName); % 构造实例
        samplingFactor = 10; % 原始采样频率是100，下采样后是10。
        
        % 把每个signal的数值写入
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
