classdef MySetField
    % 为了 id 16 17 18 25 __ 29 而封装的类
    % 这几个id场景 很相似
    
    properties
        m_DataS;
        m_fieldname;
        m_id;
        m_score;
        m_details;
        m_time_begin;
        m_time_end;
        m_kd;
    end
    
    methods
        function mysf = MySetField(DataS, fieldname, id, score, details, time_begin, time_end, kd)
            mysf.m_DataS = DataS;
            mysf.m_fieldname = fieldname;
            mysf.m_id = id;
            mysf.m_score = score;
            mysf.m_details = details;
            mysf.m_time_begin = time_begin;
            mysf.m_time_end = time_end;
            mysf.m_kd = kd;
            
        end
        
        function new = sf_loadsave(mysf, old)
%             load(mysf.m_file); % 每一个场景类都会重新 load，耗时。能否 使用单例，使
            ds = mysf.m_DataS; % DataStruct 结构体 存储所有参数
            
            % 注意：从Worksapce load过来的参数，要提前在 Arteon_start_loadsave文件中 处理好 比如filter
            old.(mysf.m_fieldname).id = mysf.m_id; % 动态index，使用 .()
            old.(mysf.m_fieldname).score = mysf.m_score;
            old.(mysf.m_fieldname).details = mysf.m_details;
            old.(mysf.m_fieldname).engine_speed = ds.sync_CAN2_Motor_12_MO_Drehzahl_01_t5(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).vehicle_speed = ds.sync_VehicleSpeed_t10(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).ax = ds.sync_AccelerationChassis_SMO_20_t11(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).ay = ds.sync_AccelerationLateral_t60_mySMO(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).acc_pedal = ds.my_acc_pedal(mysf.m_time_begin : mysf.m_time_end);
            temp1 = extendArr( ...
                    ds.sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(mysf.m_time_begin/10) : floor(mysf.m_time_end/10)),...
                    10);
            old.(mysf.m_fieldname).throttle_pos = temp1(1:end-9);
            old.(mysf.m_fieldname).kick_down = extendArr([mysf.m_kd] ,length(mysf.m_time_begin : mysf.m_time_end));
            old.(mysf.m_fieldname).engine_torque = ds.sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).transmission_input_speed = ds.my_transmission_input_speed(mysf.m_time_begin : mysf.m_time_end);
            
            
            % return
            new = old;
        end
    end
    
end

% 问题：每个id类，都有重复的代码，能否再封装---------------------------------------
%             myArteon_old.id25_start.id = thisid.m_id;
%             myArteon_old.id25_start.score = thisid.m_score;
%             myArteon_old.id25_start.details = thisid.m_details;
%             myArteon_old.id25_start.engine_speed = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id25_start.vehicle_speed = sync_VehicleSpeed_t10(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id25_start.ax = sync_AccelerationChassis_SMO_20_t11(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id25_start.ay = sync_AccelerationLateral_t60_mySMO(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id25_start.acc_pedal = my_acc_pedal(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id25_start.throttle_pos = extendArr( ...
%                     sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(thisid.m_time_begin/10) : floor(thisid.m_time_end/10)),...
%                     10);
%             myArteon_old.id25_start.kick_down = extendArr([0] ,length(thisid.m_time_begin : thisid.m_time_end));
%             myArteon_old.id25_start.engine_torque = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(thisid.m_time_begin : thisid.m_time_end);
            % --------------------------------------------------------
