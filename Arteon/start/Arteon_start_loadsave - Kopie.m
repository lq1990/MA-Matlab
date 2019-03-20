% Arteon 起步
clear;
close all;
clc;
%% ================= 25 #important KP ===========================
% 01. engine speed          14. vehicle speed       16. Longitudinal acceleration  17. Lateral acceleration
% 20. Acc. pedal position  21. Throttle position  23. Kickdown                          24. Engine torque
% 32. Transmission input speed   33. Transmission input speed odd gears
% 34. Transmission input speed even gears
%% load start(1) id: 16, 17, 18
% 16，17, 18三者是在 同一个测试环境下，间隔一定时间 评分 3次。
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');
load('.\id_16_17_18\sync_AccelerationLateral_t60_mySMO.mat');
% load 16_17_18, AcceleratorPedal.txt
acc_pedal_16_17_18 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\16-17-18\AcceleratorPedal.txt');
my_acc_pedal = acc_pedal_16_17_18.data;

arteon_id16_engine_speed_fp75_score6d8 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(6955:7255);
arteon_id17_engine_speed_fp100_score6d7 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(9155:9655);
arteon_id18_engine_speed_kd_score6d9 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(10455:10955);

arteon_id16_vehicle_speed_fp75_score6d8 = sync_VehicleSpeed_t10(6955:7255);
arteon_id17_vehicle_speed_fp100_score6d7 = sync_VehicleSpeed_t10(9155:9655);
arteon_id18_vehicle_speed_kd_score6d9 = sync_VehicleSpeed_t10(10455:10955);

arteon_id16_ax_fp75_score6d8 = sync_AccelerationChassis_SMO_20_t11(6955:7255);
arteon_id17_ax_fp100_score6d7 = sync_AccelerationChassis_SMO_20_t11(9155:9655);
arteon_id18_ax_kd_score6d9 = sync_AccelerationChassis_SMO_20_t11(10455:10955);

% be filtered
arteon_id16_ay_fp75_score6d8 = sync_AccelerationLateral_t60_mySMO(6955:7255);
arteon_id17_ay_fp100_score6d7 = sync_AccelerationLateral_t60_mySMO(9155:9655);
arteon_id18_ay_kd_score6d9 = sync_AccelerationLateral_t60_mySMO(10455:10955);

arteon_id16_acc_pedal_fp75_score6d8 = my_acc_pedal(6955:7255);
arteon_id17_acc_pedal_fp100_score6d7 = my_acc_pedal(9155:9655);
arteon_id18_acc_pedal_kd_score6d9 = my_acc_pedal(10455:10955);

arteon_id16_throttle_pos_fp75_score6d8_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(6955/10) : floor(7255/10));
arteon_id17_throttle_pos_fp100_score6d7_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(9155/10) : floor(9655/10));
arteon_id18_throttle_pos_kd_score6d9_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(10455/10) : floor(10955/10));
% be extended, 需要扩展 throttle_pos, 原始长度只有 1/10 的要求
arteon_id16_throttle_pos_fp75_score6d8 = extendArr( arteon_id16_throttle_pos_fp75_score6d8_original, 10);
arteon_id16_throttle_pos_fp75_score6d8 = arteon_id16_throttle_pos_fp75_score6d8(1: end-9);
arteon_id17_throttle_pos_fp100_score6d7 = extendArr( arteon_id17_throttle_pos_fp100_score6d7_original, 10);
arteon_id17_throttle_pos_fp100_score6d7 = arteon_id17_throttle_pos_fp100_score6d7(1: end-9);
arteon_id18_throttle_pos_kd_score6d9 = extendArr( arteon_id18_throttle_pos_kd_score6d9_original, 10);
arteon_id18_throttle_pos_kd_score6d9 = arteon_id18_throttle_pos_kd_score6d9(1: end-9);

arteon_id16_kick_down_fp75_score6d8 =extendArr([0] ,length(6955:7255));
arteon_id17_kick_down_fp100_score6d7 =extendArr([0], length(9155:9655));
arteon_id18_kick_down_kd_score6d9 =extendArr([1], length(10455:10955));

arteon_id16_engine_torque_fp75_score6d8 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(6955:7255);
arteon_id17_engine_torque_fp100_score6d7 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(9155:9655);
arteon_id18_engine_torque_kd_score6d9 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(10455:10955);

% save data in struct
myArteon.id16_start.id = 16;
myArteon.id16_start.score = 6.8;
myArteon.id16_start.details = 'Arteon, start, fp75';
myArteon.id16_start.engine_speed = arteon_id16_engine_speed_fp75_score6d8;
myArteon.id16_start.vehicle_speed = arteon_id16_vehicle_speed_fp75_score6d8;
myArteon.id16_start.ax = arteon_id16_ax_fp75_score6d8;
myArteon.id16_start.ay = arteon_id16_ay_fp75_score6d8;
myArteon.id16_start.acc_pedal = arteon_id16_acc_pedal_fp75_score6d8;
myArteon.id16_start.throttle_pos = arteon_id16_throttle_pos_fp75_score6d8;
myArteon.id16_start.kick_down = arteon_id16_kick_down_fp75_score6d8;
myArteon.id16_start.engine_torque = arteon_id16_engine_torque_fp75_score6d8;

myArteon.id17_start.id = 17;
myArteon.id17_start.score = 6.7;
myArteon.id17_start.details = 'Arteon, start, fp100';
myArteon.id17_start.engine_speed = arteon_id17_engine_speed_fp100_score6d7;
myArteon.id17_start.vehicle_speed = arteon_id17_vehicle_speed_fp100_score6d7;
myArteon.id17_start.ax = arteon_id17_ax_fp100_score6d7;
myArteon.id17_start.ay = arteon_id17_ay_fp100_score6d7;
myArteon.id17_start.acc_pedal = arteon_id17_acc_pedal_fp100_score6d7;
myArteon.id17_start.throttle_pos= arteon_id17_throttle_pos_fp100_score6d7;
myArteon.id17_start.kick_down= arteon_id17_kick_down_fp100_score6d7;
myArteon.id17_start.engine_torque= arteon_id17_engine_torque_fp100_score6d7;

myArteon.id18_start.id = 18;
myArteon.id18_start.score = 6.9;
myArteon.id18_start.details = 'Arteon, start, kickdown';
myArteon.id18_start.engine_speed = arteon_id18_engine_speed_kd_score6d9;
myArteon.id18_start.vehicle_speed = arteon_id18_vehicle_speed_kd_score6d9;
myArteon.id18_start.ax = arteon_id18_ax_kd_score6d9;
myArteon.id18_start.ay = arteon_id18_ay_kd_score6d9;
myArteon.id18_start.acc_pedal = arteon_id18_acc_pedal_kd_score6d9;
myArteon.id18_start.throttle_pos = arteon_id18_throttle_pos_kd_score6d9;
myArteon.id18_start.kick_down = arteon_id18_kick_down_kd_score6d9;
myArteon.id18_start.engine_torque = arteon_id18_engine_torque_kd_score6d9;

%% load start(2) id: 25, 26, 27, 28, 29
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');
load('.\id_25_26_27_28_29\sync_AccelerationLateral_t60_mySMO.mat');
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
my_acc_pedal = acc_pedal_25__29.data;

arteon_id25_engine_speed_fp25_score7d9 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(3436:3936);
arteon_id26_engine_speed_fp50_score7d2 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(5036:5436);
arteon_id27_engine_speed_fp75_score7d6 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(6036:6536);
arteon_id28_engine_speed_fp100_score6d4 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(7136:7536);
arteon_id29_engine_speed_kd_score6d7 = sync_CAN2_Motor_12_MO_Drehzahl_01_t5(7936:8436);

arteon_id25_vehicle_speed_fp25_score7d9 = sync_VehicleSpeed_t10(3436:3936);
arteon_id26_vehicle_speed_fp50_score7d2 = sync_VehicleSpeed_t10(5036:5436);
arteon_id27_vehicle_speed_fp75_score7d6 = sync_VehicleSpeed_t10(6036:6536);
arteon_id28_vehicle_speed_fp100_score6d4 = sync_VehicleSpeed_t10(7136:7536);
arteon_id29_vehicle_speed_kd_score6d7 = sync_VehicleSpeed_t10(7936:8436);

arteon_id25_ax_fp25_score7d9 = sync_AccelerationChassis_SMO_20_t11(3436:3936);
arteon_id26_ax_fp50_score7d2 = sync_AccelerationChassis_SMO_20_t11(5036:5436);
arteon_id27_ax_fp75_score7d6 = sync_AccelerationChassis_SMO_20_t11(6036:6536);
arteon_id28_ax_fp100_score6d4 = sync_AccelerationChassis_SMO_20_t11(7136:7536);
arteon_id29_ax_kd_score6d7 = sync_AccelerationChassis_SMO_20_t11(7936:8436);

arteon_id25_ay_fp25_score7d9 = sync_AccelerationLateral_t60_mySMO(3436:3936);
arteon_id26_ay_fp50_score7d2 = sync_AccelerationLateral_t60_mySMO(5036:5436);
arteon_id27_ay_fp75_score7d6 = sync_AccelerationLateral_t60_mySMO(6036:6536);
arteon_id28_ay_fp100_score6d4 = sync_AccelerationLateral_t60_mySMO(7136:7536);
arteon_id29_ay_kd_score6d7 = sync_AccelerationLateral_t60_mySMO(7936:8436);

arteon_id25_acc_pedal_fp25_score7d9 = my_acc_pedal(3436:3936);
arteon_id26_acc_pedal_fp50_score7d2 = my_acc_pedal(5036:5436);
arteon_id27_acc_pedal_fp75_score7d6 = my_acc_pedal(6036:6536);
arteon_id28_acc_pedal_fp100_score6d4 = my_acc_pedal(7136:7536);
arteon_id29_acc_pedal_kd_score6d7 = my_acc_pedal(7936:8436);

arteon_id25_throttle_pos_fp25_score7d9_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(3436/10) : floor(3936/10));
arteon_id26_throttle_pos_fp50_score7d2_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(5036/10) : floor(5436/10));
arteon_id27_throttle_pos_fp75_score7d6_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(6036/10) : floor(6536/10));
arteon_id28_throttle_pos_fp100_score6d4_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(7136/10) : floor(7536/10));
arteon_id29_throttle_pos_kd_score6d7_original = sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7(floor(7936/10) : floor(8436/10));
% 扩展
arteon_id25_throttle_pos_fp25_score7d9 = extendArr(arteon_id25_throttle_pos_fp25_score7d9_original, 10);
arteon_id25_throttle_pos_fp25_score7d9 = arteon_id25_throttle_pos_fp25_score7d9(1: end-9);
arteon_id26_throttle_pos_fp50_score7d2 = extendArr(arteon_id26_throttle_pos_fp50_score7d2_original, 10);
arteon_id26_throttle_pos_fp50_score7d2 = arteon_id26_throttle_pos_fp50_score7d2(1: end-9);
arteon_id27_throttle_pos_fp75_score7d6 = extendArr(arteon_id27_throttle_pos_fp75_score7d6_original, 10);
arteon_id27_throttle_pos_fp75_score7d6 = arteon_id27_throttle_pos_fp75_score7d6(1: end-9);
arteon_id28_throttle_pos_fp100_score6d4 = extendArr(arteon_id28_throttle_pos_fp100_score6d4_original, 10);
arteon_id28_throttle_pos_fp100_score6d4 = arteon_id28_throttle_pos_fp100_score6d4(1: end-9);
arteon_id29_throttle_pos_kd_score6d7 = extendArr(arteon_id29_throttle_pos_kd_score6d7_original, 10);
arteon_id29_throttle_pos_kd_score6d7 = arteon_id29_throttle_pos_kd_score6d7(1: end-9);

arteon_id25_kick_down_fp25_score7d9 =extendArr([0], length(3436:3936));
arteon_id26_kick_down_fp50_score7d2 = extendArr([0], length(5036:5436));
arteon_id27_kick_down_fp75_score7d6 = extendArr([0], length(6036:6536));
arteon_id28_kick_down_fp100_score6d4 = extendArr([0], length(7136:7536));
arteon_id29_kick_down_kd_score6d7 = extendArr([1], length(7936:8436));

arteon_id25_engine_torque_fp25_score7d9 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(3436:3936);
arteon_id26_engine_torque_fp50_score7d2 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(5036:5436);
arteon_id27_engine_torque_fp75_score7d6 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(6036:6536);
arteon_id28_engine_torque_fp100_score6d4 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(7136:7536);
arteon_id29_engine_torque_kd_score6d7 = sync_CAN2_Motor_11_MO_Mom_Ist_Summe_t4(7936:8436);

% save data in struct
myArteon.id25_start.id = 25;
myArteon.id25_start.score = 7.9;
myArteon.id25_start.details = 'Arteon, start, fp25';
myArteon.id25_start.engine_speed = arteon_id25_engine_speed_fp25_score7d9;
myArteon.id25_start.vehicle_speed = arteon_id25_vehicle_speed_fp25_score7d9;
myArteon.id25_start.ax = arteon_id25_ax_fp25_score7d9;
myArteon.id25_start.ay = arteon_id25_ay_fp25_score7d9;
myArteon.id25_start.acc_pedal = arteon_id25_acc_pedal_fp25_score7d9;
myArteon.id25_start.throttle_pos = arteon_id25_throttle_pos_fp25_score7d9;
myArteon.id25_start.kick_down = arteon_id25_kick_down_fp25_score7d9;
myArteon.id25_start.engine_torque = arteon_id25_engine_torque_fp25_score7d9;

myArteon.id26_start.id = 26;
myArteon.id26_start.score = 7.2;
myArteon.id26_start.details = 'Arteon, start, fp50';
myArteon.id26_start.engine_speed = arteon_id26_engine_speed_fp50_score7d2;
myArteon.id26_start.vehicle_speed = arteon_id26_vehicle_speed_fp50_score7d2;
myArteon.id26_start.ax = arteon_id26_ax_fp50_score7d2;
myArteon.id26_start.ay = arteon_id26_ay_fp50_score7d2;
myArteon.id26_start.acc_pedal = arteon_id26_acc_pedal_fp50_score7d2;
myArteon.id26_start.throttle_pos = arteon_id26_throttle_pos_fp50_score7d2;
myArteon.id26_start.kick_down = arteon_id26_kick_down_fp50_score7d2;
myArteon.id26_start.engine_torque = arteon_id26_engine_torque_fp50_score7d2;

myArteon.id27_start.id = 27;
myArteon.id27_start.score = 7.6;
myArteon.id27_start.details = 'Arteon, start, fp75';
myArteon.id27_start.engine_speed = arteon_id27_engine_speed_fp75_score7d6;
myArteon.id27_start.vehicle_speed = arteon_id27_vehicle_speed_fp75_score7d6;
myArteon.id27_start.ax = arteon_id27_ax_fp75_score7d6;
myArteon.id27_start.ay = arteon_id27_ay_fp75_score7d6;
myArteon.id27_start.acc_pedal = arteon_id27_acc_pedal_fp75_score7d6;
myArteon.id27_start.throttle_pos = arteon_id27_throttle_pos_fp75_score7d6;
myArteon.id27_start.kick_down = arteon_id27_kick_down_fp75_score7d6;
myArteon.id27_start.engine_torque =arteon_id27_engine_torque_fp75_score7d6;

myArteon.id28_start.id = 28;
myArteon.id28_start.score = 6.4;
myArteon.id28_start.details = 'Arteon, start, fp100';
myArteon.id28_start.engine_speed = arteon_id28_engine_speed_fp100_score6d4;
myArteon.id28_start.vehicle_speed = arteon_id28_vehicle_speed_fp100_score6d4;
myArteon.id28_start.ax = arteon_id28_ax_fp100_score6d4;
myArteon.id28_start.ay = arteon_id28_ay_fp100_score6d4;
myArteon.id28_start.acc_pedal = arteon_id28_acc_pedal_fp100_score6d4;
myArteon.id28_start.throttle_pos = arteon_id28_throttle_pos_fp100_score6d4;
myArteon.id28_start.kick_down = arteon_id28_kick_down_fp100_score6d4;
myArteon.id28_start.engine_torque =arteon_id28_engine_torque_fp100_score6d4;

myArteon.id29_start.id = 29;
myArteon.id29_start.score = 6.7;
myArteon.id29_start.details = 'Arteon, start, kickdown';
myArteon.id29_start.engine_speed = arteon_id29_engine_speed_kd_score6d7;
myArteon.id29_start.vehicle_speed = arteon_id29_vehicle_speed_kd_score6d7;
myArteon.id29_start.ax = arteon_id29_ax_kd_score6d7;
myArteon.id29_start.ay = arteon_id29_ay_kd_score6d7;
myArteon.id29_start.acc_pedal = arteon_id29_acc_pedal_kd_score6d7;
myArteon.id29_start.throttle_pos = arteon_id29_throttle_pos_kd_score6d7;
myArteon.id29_start.kick_down = arteon_id29_kick_down_kd_score6d7;
myArteon.id29_start.engine_torque = arteon_id29_engine_torque_kd_score6d7;

%%
% struct2array
myArteonArr = struct2array(myArteon);

% save
save myArteon myArteon
save myArteonArr myArteonArr

disp('save over')


