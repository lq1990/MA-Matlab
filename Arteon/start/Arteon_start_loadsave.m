% Arteon 起步
clear; clc; close all;

time_start = datetime;

addpath(genpath(pwd)); % 添加所有子目录

%% ================= 25 #important KP ===========================
% 01. engine speed          14. vehicle speed       16. Longitudinal acceleration  17. Lateral acceleration
% 20. Acc. pedal position  21. Throttle position  23. Kickdown                          24. Engine torque
% 32. Transmission input speed   *33. Transmission input speed odd gears
% *34. Transmission input speed even gears  *39. Driving program
% *40. Current gear  42. Target gear  *45. Gear shift suppressed  
% 46. Shift process  47. Shift in process  48. Clutch odd status
% 49. Clutch even status  51. Brake pressure raw value  52. Brake pressed
% 53. *Microphone signal  56. Steering wheel angle  58. Steering wheel speed
% 60. ACC status

%% load start(1) id: 16, 17, 18
% 16，17, 18三者是在 同一个测试环境下，间隔一定时间 评分 3次。
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');
% load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat')

% -------------- 原始数据不符合要求， 比如需要 filtered, extended ------------------
temp_ay = load('.\id_16_17_18\my_ay.mat');
loadDataS.my_ay = temp_ay.my_ay;
acc_pedal_16_17_18 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\16-17-18\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_16_17_18.data;
loadDataS.my_throttle_pos = extendArr(loadDataS.sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7, 10);
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2); % Transmission input speed
loadDataS.my_target_gear = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Zielgang_t3, 5);
loadDataS.my_shift_process = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Schaltablauf_t2, 5);
loadDataS.my_brake_pressure_raw = extendArr(loadDataS.sync_CAN2_ESP_05_ESP_Bremsdruck_t9, 2);

% -------------------------------------------------------------------------------------
% 把所有场景对应的数据已经预先处理，并存储后，再进行如下
myArteon = struct; % init一个空struct
myArteon = ID16Start.loadsave(loadDataS, myArteon);
myArteon = ID17Start.loadsave(loadDataS, myArteon);
myArteon = ID18Start.loadsave(loadDataS, myArteon); 
% id 16 17 18 数据来源于一个大场景，因此只需要load一次数据，可实际上在三个类中各自都load了一次，改进？！方法：传参数

%% load start(2) id: 25, 26, 27, 28, 29
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');
% load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat')

% -------------- 原始数据不符合要求， 比如需要 filtered, extended ------------------
temp_ay = load('.\id_25_26_27_28_29\my_ay.mat');
loadDataS.my_ay = temp_ay.my_ay;
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_25__29.data;
loadDataS.my_throttle_pos = extendArr(loadDataS.sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7, 10);
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2); % Transmission input speed
loadDataS.my_target_gear = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Zielgang_t3, 5);
loadDataS.my_shift_process = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Schaltablauf_t2, 5);
loadDataS.my_brake_pressure_raw = extendArr(loadDataS.sync_CAN2_ESP_05_ESP_Bremsdruck_t9, 2);

% ------------------------------------------------------------------------------------------
% 把场景中数据，存储如下
myArteon = ID25Start.loadsave(loadDataS, myArteon);
myArteon = ID26Start.loadsave(loadDataS, myArteon);
myArteon = ID27Start.loadsave(loadDataS, myArteon);
myArteon = ID28Start.loadsave(loadDataS, myArteon);
myArteon = ID29Start.loadsave(loadDataS, myArteon); % id 25 - 29 数据来源于一个大场景


%% load start(3.1) id 121-126
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_07.02.18_Nachmittag_dry\Syncdaten\ohne startstop all_sync.mat');
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_07.02.18_Nachmittag_dry\Syncdaten\ohne startstop all_sync.mat');

% -------------- 原始数据不符合要求， 比如需要 filtered, extended ------------------
temp_ay = load('.\id_121__126\my_ay.mat');
loadDataS.my_ay = temp_ay.my_ay;
acc_pedal =...
    importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_07.02.18_Nachmittag_dry\AVL_Drive\ohne startstop all\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal.data;
loadDataS.my_throttle_pos = extendArr(loadDataS.sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7, 10);
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2); % Transmission input speed
loadDataS.my_target_gear = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Zielgang_t3, 5);
loadDataS.my_shift_process = extendArr(loadDataS.sync_CAN2_Getriebe_11_GE_Schaltablauf_t2, 5);
loadDataS.my_brake_pressure_raw = extendArr(loadDataS.sync_CAN2_ESP_05_ESP_Bremsdruck_t9, 2);

% ------------------------------------------------------------------------------------------
% 把场景中数据，存储如下, % id 121-126 数据来源于一个大场景
myArteon = ID121Start.loadsave(loadDataS, myArteon);
myArteon = ID122_1Start.loadsave(loadDataS, myArteon);
myArteon = ID122_2Start.loadsave(loadDataS, myArteon);
myArteon = ID122_3Start.loadsave(loadDataS, myArteon);
myArteon = ID123Start.loadsave(loadDataS, myArteon);
myArteon = ID124Start.loadsave(loadDataS, myArteon);
myArteon = ID125Start.loadsave(loadDataS, myArteon);
myArteon = ID126Start.loadsave(loadDataS, myArteon); 

% ------------- 遇到问题： ---------------
% 使用sync数据但是却用 AVL时间，是不准确的。
% 方法：使用AVL数据和AVL时间。那所有的KP都要预处理, my_ 前缀表示

%% load start(3.2) id 127


%%
myArteonArr = struct2array(myArteon);

save './DataFinalSave/myArteon' myArteon
save './DataFinalSave/myArteonArr' myArteonArr

disp('---------------> save over <-------------------')

time_end = datetime; disp('all time needed: '); disp(time_end - time_start);
