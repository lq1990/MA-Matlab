classdef ID25Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id25_start';
        m_id = 25;
        m_score = 7.9;
        m_details = 'Arteon, Start, Fp25'
        m_time_begin = 3436;
        m_time_end = 3936;
    end
    
    methods
        function thisid = ID25Start()
            disp('now id25...');
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID25Start;
            
%             addpath(genpath(pwd));
            sf = MySetField(file,...
                thisid.m_fieldname,...
                thisid.m_id,...
                thisid.m_score,...
                thisid.m_details,...
                thisid.m_time_begin,...
                thisid.m_time_end);
            myArteon_new = sf.sf_loadsave(myArteon_old);
            
%             load(file) % 每个id类都要 重新load，耗时，尝试做成一个 单例，实现共享
%             
%             % 问题：每个id类，都有重复的代码，能否再封装---------------------------------------
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
%             % --------------------------------------------------------


            
            % return
%             myArteon_new = myArteon_old;
        end
    end
    
end

