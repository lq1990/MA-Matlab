classdef ID18Start
    % id 18 start 测试场景
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id18_start';
        m_id = 18;
        m_score = 6.9;
        m_details = 'Arteon, Start, KickDown'
        m_time_begin = 10455;
        m_time_end = 10955;
        m_kd = 1;
    end
    
    methods
        function thisid = ID18Start()
            disp('now id18...');
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID18Start;

%             addpath(genpath(pwd));
            sf = MySetField(file,...
                thisid.m_fieldname,...
                thisid.m_id,...
                thisid.m_score,...
                thisid.m_details,...
                thisid.m_time_begin,...
                thisid.m_time_end,...
                thisid.m_kd);
            myArteon_new = sf.sf_loadsave(myArteon_old);
            
%             load(file)
%             
%             myArteon_old.id18_start.id = thisid.m_id;
%             myArteon_old.id18_start.score = thisid.m_score;
%             myArteon_old.id18_start.details = thisid.m_details;
%             myArteon_old.id18_start.engine_speed = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id18_start.vehicle_speed = sync_VehicleSpeed_t10(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id18_start.ax = sync_AccelerationChassis_SMO_20_t11(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id18_start.ay = sync_AccelerationLateral_t60_mySMO(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id18_start.acc_pedal = my_acc_pedal(thisid.m_time_begin : thisid.m_time_end);
%             myArteon_old.id18_start.throttle_pos = extendArr( ...
%                     sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(thisid.m_time_begin/10) : floor(thisid.m_time_end/10)),...
%                     10);
%             myArteon_old.id18_start.kick_down = extendArr([0] ,length(thisid.m_time_begin : thisid.m_time_end));
%             myArteon_old.id18_start.engine_torque = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(thisid.m_time_begin : thisid.m_time_end);
%             
%             myArteon_new = myArteon_old;
        end
    end
    
end

