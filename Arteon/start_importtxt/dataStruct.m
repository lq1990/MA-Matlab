% �洢���г������У���Ӧ������KP���У��ģ�
% �ļ���
% �ļ�����Ŀ¼

clc; clear; close all;
addpath(genpath(pwd));
%%
scenarioTable = importfile_scenario('scenarioList.txt', 2, 4);
kpTable = importfile_kp('kpOfTxtList.txt', 2, 12); % txt�д洢

% ȡ�� ����id17���������˵�Ԥ������AccPedal��������������
dataS = struct; % �洢����kp����

% id = 17;
% idx = find(scenarioTable.id==id);
% fieldname = scenarioTable(idx, 'fieldname').fieldname{1,1};
% dir = scenarioTable(idx, 'dir').dir{1,1}; % �� table -> cell -> char

for i = 1 : height(scenarioTable)
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario);
    details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % һ�������µģ�ʱ�俪ʼ
    t_end = scenarioTable.t_end(idx_scenario); % һ�������µģ�ʱ���ֹ
    dir_cell = scenarioTable.dir(idx_scenario);
    dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario);
    fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    for j = 1: height(kpTable) % ��ͬһ��id�£�����kpʹ��һ���� ʱ����ֹ
        idx_kp = j;
        kpname_cell = kpTable.kpName(idx_kp); % kpά�Ⱥ� id����ά�ȶ���
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

