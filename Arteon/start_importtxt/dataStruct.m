% 存储所有场景（行）对应的所有KP（列）的：
% 文件名
% 文件所在目录

clc; clear; close all;
addpath(genpath(pwd));
%% txt to table
scenarioTable = importfile_scenario('scenarioList.txt');
kpTable = importfile_kp('kpOfTxtList.txt'); % txt中存储
save '.\src\kpTable' kpTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% 将场景对应kp 数据存在 dataSArr.mat

% 取出 场景id17，经过过滤等预处理后的AccPedal。共给场景类用
dataS = struct; % 存储所有kp数据


for i = 1 : height(scenarioTable) % loop over scenarioTable
    % 对应dataSArr 行
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % 一个场景下的，时间开始
    t_end = scenarioTable.t_end(idx_scenario); % 一个场景下的，时间截止
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    for j = 1: height(kpTable) % 在同一个id下，所有kp使用一样的 时间起止
        % 对应 dataSArr 列
        idx_kp = j;
        kpname_cell = kpTable.kpName(idx_kp); kpname = kpname_cell{1,1};% kp维度和 id场景维度独立
        filename_cell = kpTable.filename(idx_kp); filename = filename_cell{1,1};
        
        akp = KP(filename, dir);
        akp_alldata = akp.import();
        
        akp_clip = akp_alldata(t_begin : t_end);
        dataS.(fieldname).(kpname) = akp_clip;
    end
    
end

clearvars idx_kp idx_scenario id score details_cell details t_begin t_end dir_cell dir;
clearvars fieldname_cell fieldname i j kpname kpname_cell filename filename_cell akp akp_alldata akp_clip;
disp('---------------- loop over 2/3 ----------------');

%%
dataSArr = struct2array(dataS);
save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

disp('--------------- save over 3/3 -----------------');
