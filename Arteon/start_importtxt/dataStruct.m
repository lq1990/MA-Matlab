% 存储所有场景（行）对应的所有KP（列）的：
% 文件名
% 文件所在目录

clc; clear; close all;
addpath(genpath(pwd));
%%
scenarioTable = importfile_scenario('scenarioList.txt', 2, 4);
kpTable = importfile_kp('kpOfTxtList.txt', 2, 12); % txt中存储

% 取出 场景id17，经过过滤等预处理后的AccPedal。共给场景类用
dataS = struct; % 存储所有kp数据

% id = 17;
% idx = find(scenarioTable.id==id);
% fieldname = scenarioTable(idx, 'fieldname').fieldname{1,1};
% dir = scenarioTable(idx, 'dir').dir{1,1}; % 把 table -> cell -> char

for i = 1 : height(scenarioTable)
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario);
    details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % 一个场景下的，时间开始
    t_end = scenarioTable.t_end(idx_scenario); % 一个场景下的，时间截止
    dir_cell = scenarioTable.dir(idx_scenario);
    dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario);
    fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    for j = 1: height(kpTable) % 在同一个id下，所有kp使用一样的 时间起止
        idx_kp = j;
        kpname_cell = kpTable.kpName(idx_kp); % kp维度和 id场景维度独立
        kpname = kpname_cell{1,1};
        filename_cell = kpTable.filename(idx_kp);
        filename = filename_cell{1,1};
        
        akp = KP(kpname, filename, dir);
        akp_alldata = akp.import();
        akp_clip = akp_alldata(t_begin : t_end);
        dataS.(fieldname).(kpname) = akp_clip;
    end
    
end

disp('---------------- loop over ----------------');

%%
dataSArr = struct2array(dataS);
save dataS dataS
save dataSArr dataSArr

