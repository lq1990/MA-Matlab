% src data (txt files) transform into struct/arr/list ...
function [out_dataS, out_scenarioTable, out_signalTable] = srcDataTrans_gearS(scenarioFile, signalFile, sampling_factor, car_type)
    % ���� ������signal ����txt�ļ�����ԭ�����н���Ԥ����
    % ������洢���г������У���Ӧ������signal���У�
    % sampling_factor = 100 ; % ԭʼ����Ƶ����100���²�������10���ϲ���Ϊ100hz

    t0 = clock; % ͳ������ʱ��
    %% txt to table
    scenarioTable = importfile_scenario(scenarioFile);
%     fprintf('height(scenarioTable): %d\n', height(scenarioTable));
    signalTable = importfile_signal(signalFile); % txt�д洢
    
    out_scenarioTable = scenarioTable;
    out_signalTable = signalTable;

    disp('----------- importfile scenarios and signals,  txt to table over 1/5 ----------------');

    %% ��������Ӧsignal ���ݴ��� dataSArr.mat

    dataS = struct; % �洢����kp����
    % Ϊ��������ݸ��ã�������ʱstruct
    % ֻ�е� ��ǰdir����һ��dir��ͬʱ�������¼���. ��dir��ͬ����û��Ҫ���� �˷�ʱ�䡣
    tmp_asignal_val_factor = struct;

    for i = 1 : height(scenarioTable) % loop over scenarioTable
        % ��ӦdataSArr ��
        id = scenarioTable.id(i);
        fprintf('======================\nid: %.2f\n', id);
        score = scenarioTable.score(i);
        details_cell = scenarioTable.details(i); details= details_cell{1,1};
        t_begin = scenarioTable.t_begin(i); t_begin = t_begin/100; % һ�������µģ�ͬһ����ʱ�俪ʼ
        t_end = scenarioTable.t_end(i); t_end = t_end/100; % һ�������µģ�ͬһ����ʱ���ֹ
        dir_cell = scenarioTable.dir(i); dir = dir_cell{1,1}; % dir������ ����·���µ�mat�ļ�
        fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};

        dataS.(fieldname).id = id;
        dataS.(fieldname).fieldname = fieldname;
        dataS.(fieldname).score = score;
        dataS.(fieldname).details = details;

        % ��ȡĳһ�� signal��ÿһ����һ������������һ�� mat ����
        % �Աȵ�ǰ�е�dir �Ƿ����һ��һ����һ���Ļ����Ͳ���������load
        if i == 1
            ds = load(dir);
        else
            dir_cell_cur = scenarioTable.dir(i); dir_cur = dir_cell_cur{1,1};
            dir_cell_pre = scenarioTable.dir(i-1); dir_pre = dir_cell_pre{1,1};
            if strcmp(dir_cur, dir_pre) == 0
                dir_flag = 0;
                % ֻ�е� ��ǰdir����һ��dir��ͬʱ����load��% ��dir��ͬ����û��Ҫ��load�˷�ʱ�䡣
                ds = load(dir);
            else
                dir_flag = 1;
            end
        end

        % ÿһ������������ idx_v30��ȡmin(idx_v30, idx_t_end) ��Ϊ������ idx_t_end
        % Ϊ�����Ͳ������㣬�ڱ��ļ��ĺ������

        for j = 1: height(signalTable) % ��ͬһ��id�£�����signal ʹ��һ���� ʱ����ֹ
            % ��Ӧ dataSArr �У�����Ӧÿһ��signal��ÿ��signal���ڲ�����ͬ��ʱ����ֹ��ͬ����Ҫ�����idx_t
            idx_signal = j;
            signalName_cell = signalTable.signalName(idx_signal); signalName = signalName_cell{1,1}; % kpά�Ⱥ� id����ά�ȶ���
            signalSyncName_cell = signalTable.signalSyncName(idx_signal); signalSyncName = signalSyncName_cell{1,1};
            signalTimeName_cell = signalTable.signalTimeName(idx_signal); signalTimeName = signalTimeName_cell{1,1};

            asignal = MySignal(ds, signalSyncName, signalTimeName, car_type); % ����ʵ��
            % ��Ҫ signalTimeName����Ϊ��Ҫ����time�ҵ�idx

            try
                % �п���ĳһ��file�����ڣ�������
                % load(), load_filter(), load_extend(), load_filter_extend() �ֳ�����
                % �²��������������ٵ�Ϊ׼��
                % maxLen: 17901, minLen: 1790��10���Ĺ�ϵ������߲���100hz�����10hz 

                reuse_flag = 1 ;
                if reuse_flag == 1
                    % ʹ��tmpʵ�����ݸ��ã����Լ����1s��Ч�������ԣ���Ϊʹ��tmp��дҲ����ʱ�䡣
                     if i == 1
                         % ��һ����������Ҫ���㣬�ҳ�ʼ��tmp��ֵ��
                        [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor);
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
                            [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor); % ���ݱ�extend��filter
                            tmp_asignal_val_factor.(signalName).data = asignal_alldata;
                            tmp_asignal_val_factor.(signalName).factor = factor;
                        end
                     end
                else
                    % ���ø���
                    [asignal_alldata, factor ] = tryASignalAllData(asignal, signalName, sampling_factor);
                end

                % ���ճ���ʱ�䣬�ҵ�val�� idx��ֹ�ü�.
            % ������������Ȼ t_begin t_endһ���������ڲ�ͬsignal����Ƶ�ʲ�ͬ��ʹidx�����в�ͬ��
            % ͨ����ͬsignal��sync_t�ҵ� t_begin��Ӧ��idx_t_begin��������һЩ��� idx_t_end���ɱ�֤signal����׼ȷ
                [idx_t_begin, idx_t_end] = asignal.findIdxTT(t_begin, t_end, factor, sampling_factor);

    %             disp(signalName);
    %             fprintf('length(asignal_alldata): %d \n',length(asignal_alldata));
    %             fprintf('idx_t_begin: %d \n',idx_t_begin);
    %             fprintf('idx_t_end: %d \n',idx_t_end);

                asignal_clip = asignal_alldata(idx_t_begin : idx_t_end);
                dataS.(fieldname).(signalName) = asignal_clip;

            catch
                % �� ������NaN����� try/catchע�ͣ��鿴ԭ��Ӧ����ȷ��������Դ��ֻ�е�fileȷʵ�����ڲ�����NaN��
                % ���ĳһ���ļ������ڣ�������һ������ NaN
                asignal_alldata = linspace(NaN, NaN, round(t_end-t_begin) * sampling_factor); % ����100����ΪUp�����Ĳ���Ƶ����100hz
                asignal_alldata = transpose(asignal_alldata);
                dataS.(fieldname).(signalName) = asignal_alldata;

                fprintf('NaN, fieldname: %s, signalname: %s\n', fieldname, signalName);
            end

        end

    end

    disp('---------------- get dataS over 2/5 ----------------');

    %% Only For Start, ���� AccePedal = 0�������ݵ���ʼλ��idx_ap0 ���� ΢��
    % ���� AccePedal ��һ����valΪ0�����ڶ�����Ҫ >0
    % Ŀǰ�м���������FP����ʱ��һ������0.
% 
%     for i = 1 : height(scenarioTable)
%         % ����ÿһ������
%          fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
%          ap = dataS.(fieldname).AccePedal; % �õ� AccePedal ���������
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
%          % �ü�ÿ�� signal
%          for j = 1: height(signalTable)
%              signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
%              dataS.(fieldname).(signalName) =  dataS.(fieldname).(signalName)(idx_ap0 : end);
%          end
% 
%     end
% 
%     disp('---------------- clip by AccePedal=0 at the begining of Start over 3/5 ----------------');

    %% For All Scenarios (as default), ��֤ NaN ��signal���ݳ��� ������signalһ��
    
    for i = 1 : height(scenarioTable)
         % get length_target
         fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
         es = dataS.(fieldname).EngineSpeed;
         length_target = length(es); % Ŀ�곤��

         % ����ÿ��������ÿ��signal��ȷ������ΪNaN�ĳ���signal���Ⱥ�����signalһ��
         for j = 1: height(signalTable)
            signalName_cell = signalTable.signalName(j); signalName = signalName_cell{1,1};
            signal_data = dataS.(fieldname).(signalName);
            if numel(signal_data)==0 || isnan(signal_data(1))
                % ����NaN������� ����һ�£���ֵΪ0
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
         for i = 1 : height(scenarioTable) % ���for����ÿһ������
             fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
             
             for j = 1 : length(dataS.(fieldname).TransmInpSpeed) % �ڲ�for���� TransmInpSpeed��ÿ��Ԫ��
                 TransmInpSpeedOdd = dataS.(fieldname).TransmInpSpeedOdd(j);
                 TransmInpSpeedEven = dataS.(fieldname).TransmInpSpeedEven(j);
                 CurrentGear = dataS.(fieldname).CurrentGear(j); % ʹ�� CurrentGear��Odd/Even������ϳ�
                 
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
    
    %% �����еĳ�������һ�� feature��isArteon
    for i = 1 : height(scenarioTable)
        fieldname_cell = scenarioTable.fieldname(i); fieldname = fieldname_cell{1,1};
        es = dataS.(fieldname).EngineSpeed;
        length_target = length(es); % Ŀ�곤��
         
        dataS.(fieldname).isArteon = linspace(0, 0, length_target)';
        
        if str2num( fieldname(3)) == 1
            % fieldname of Arteon = 'id10xx'
            dataS.(fieldname).isArteon = linspace(1, 1, length_target)';
        end
        
    end
    
    out_dataS = dataS;
    
    
     disp('--------------- add feature: isArteon,  over -----------------');
    
    %% ���ֳ������� TransmInpSpeedOdd/Even and CurrentGear ȥ����ͬʱ�� signalTable.mat�� Odd/Even and CurrentGearȥ��
    
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
%     tmp = []; % �洢Ҫ��������
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
