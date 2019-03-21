classdef MySetField
    % Ϊ�� id 16 17 18 25 __ 29 ����װ����
    % �⼸��id���� ������
    
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
            ds = mysf.m_DataS; % DataStruct �ṹ�� �洢���в���
            
            % ע�⣺��Worksapce load�����Ĳ�����Ҫ��ǰ�� Arteon_start_loadsave�ļ��� ����� ����filter
            old.(mysf.m_fieldname).id = mysf.m_id; % ��̬index��ʹ�� .()
            old.(mysf.m_fieldname).score = mysf.m_score;
            old.(mysf.m_fieldname).details = mysf.m_details;
            old.(mysf.m_fieldname).engine_speed = ds.sync_CAN2_Motor_12_MO_Drehzahl_01_t5(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).vehicle_speed = ds.sync_VehicleSpeed_t10(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).ax = ds.sync_AccelerationChassis_SMO_20_t11(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).ay = ds.sync_AccelerationLateral_t60_mySMO(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).acc_pedal = ds.my_acc_pedal(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).throttle_pos = ds.my_throttle_pos(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).kick_down = extendArr([mysf.m_kd] ,length(mysf.m_time_begin : mysf.m_time_end));
            old.(mysf.m_fieldname).engine_torque = ds.sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).transmission_input_speed = ds.my_transmission_input_speed(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).target_gear = ds.my_target_gear(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).shift_process = ds.my_shift_process(mysf.m_time_begin : mysf.m_time_end);
            old.(mysf.m_fieldname).brake_pressure_raw = ds.my_brake_pressure_raw(mysf.m_time_begin : mysf.m_time_end);
            
            % return
            new = old;
        end
    end
    
end
