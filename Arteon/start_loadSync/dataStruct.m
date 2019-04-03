% �洢���г������У���Ӧ������KP���У��ģ�
% �ļ���
% �ļ�����Ŀ¼

clc; clear; close all;
addpath(genpath(pwd));
%% txt to table
scenarioTable = importfile_scenario('scenarioList.txt');
kpTable = importfile_kp('kpOfTxtList.txt'); % txt�д洢
save '.\src\kpTable' kpTable
save '.\src\scenarioTable' scenarioTable

disp('----------- txt to table over 1/3 ----------------');
%% ��������Ӧkp ���ݴ��� dataSArr.mat

% ȡ�� ����id17���������˵�Ԥ������AccPedal��������������
dataS = struct; % �洢����kp����

for i = 1 : height(scenarioTable) % loop over scenarioTable
    % ��ӦdataSArr ��
    idx_scenario = i;
    id = scenarioTable.id(idx_scenario);
    fprintf('id: %d\n', id);
    score = scenarioTable.score(idx_scenario);
    details_cell = scenarioTable.details(idx_scenario); details= details_cell{1,1};
    t_begin = scenarioTable.t_begin(idx_scenario); % һ�������µģ�ʱ�俪ʼ
    t_end = scenarioTable.t_end(idx_scenario); % һ�������µģ�ʱ���ֹ
    dir_cell = scenarioTable.dir(idx_scenario); dir = dir_cell{1,1};
    fieldname_cell = scenarioTable.fieldname(idx_scenario); fieldname = fieldname_cell{1,1};
    
    dataS.(fieldname).id = id;
    dataS.(fieldname).score = score;
    dataS.(fieldname).details = details;

    for j = 1: height(kpTable) % ��ͬһ��id�£�����kpʹ��һ���� ʱ����ֹ
        % ��Ӧ dataSArr ��
        idx_kp = j;
        kpname_cell = kpTable.kpName(idx_kp); kpname = kpname_cell{1,1};% kpά�Ⱥ� id����ά�ȶ���
        filename_cell = kpTable.filename(idx_kp); filename = filename_cell{1,1};
        
        akp = KP(filename, dir);
        try
            % �п���ĳһ��file�����ڣ�������
            if strcmp(kpname, 'Ay')  ||...
                    strcmp(kpname, 'AcceVerticalWheel') ||...
                    strcmp(kpname, 'AcceSeat') ||...
                    strcmp(kpname, 'Power') ||...
                    strcmp(kpname, 'EngineTorque')
                % ��Ҫ�˲�
                akp_alldata = akp.import_filter(13); % ������˲��� cut_off: 13 Hz
            else
                akp_alldata = akp.import(); % �������ݣ�����Ҫ�˲���ֱ�ӵ�����С�
            end

            akp_clip = akp_alldata(t_begin : t_end);
            dataS.(fieldname).(kpname) = akp_clip;
            
        catch
            % ���ĳһ���ļ������ڣ�������һ������ NaN
            akp_alldata = linspace(NaN, NaN, t_end-t_begin+1);
            akp_alldata = transpose(akp_alldata);
            dataS.(fieldname).(kpname) = akp_alldata;

            fprintf('NaN, fieldname: %s, kpname: %s\n', fieldname, kpname);
        end
        
    end
    
end

clearvars idx_kp idx_scenario id score details_cell details t_begin t_end dir_cell dir mf;
clearvars fieldname_cell fieldname i j kpname kpname_cell filename filename_cell akp akp_alldata akp_clip;
disp('---------------- loop over 2/3 ----------------');

%%
dataSArr = struct2array(dataS);
save '.\DataFinalSave\dataS' dataS
save '.\DataFinalSave\dataSArr' dataSArr

disp('--------------- save over 3/3 -----------------');
