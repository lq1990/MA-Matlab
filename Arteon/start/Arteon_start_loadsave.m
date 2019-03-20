% Arteon 起步
clear; clc; close all;

time_start = datetime;

addpath(genpath(pwd)); % 添加所有子目录

%% ================= 25 #important KP ===========================
% 01. engine speed          14. vehicle speed       16. Longitudinal acceleration  17. Lateral acceleration
% 20. Acc. pedal position  21. Throttle position  23. Kickdown                          24. Engine torque
% 32. Transmission input speed   33. Transmission input speed odd gears
% 34. Transmission input speed even gears

%% load start(1) id: 16, 17, 18
% 16，17, 18三者是在 同一个测试环境下，间隔一定时间 评分 3次。
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');

% -------------- 原始数据不符合要求， 比如需要 filtered, extended ------------------
temp_ay = load('.\id_16_17_18\sync_AccelerationLateral_t60_mySMO.mat');
loadDataS.sync_AccelerationLateral_t60_mySMO = temp_ay.sync_AccelerationLateral_t60_mySMO;
acc_pedal_16_17_18 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\16-17-18\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_16_17_18.data;
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2); % Transmission input speed

% -------------------------------------------------------------------------------------
% 把所有场景对应的数据已经预先处理，并存储后，再进行如下
myArteon = struct; % init一个空struct
myArteon = ID16Start.loadsave(loadDataS, myArteon);
myArteon = ID17Start.loadsave(loadDataS, myArteon);
myArteon = ID18Start.loadsave(loadDataS, myArteon); 
% id 16 17 18 数据来源于一个大场景，因此只需要load一次数据，可实际上在三个类中各自都load了一次，改进？！方法：传参数

%% load start(2) id: 25, 26, 27, 28, 29
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');

% -------------- 原始数据不符合要求， 比如需要 filtered, extended ------------------
temp_ay = load('.\id_25_26_27_28_29\sync_AccelerationLateral_t60_mySMO.mat');
loadDataS.sync_AccelerationLateral_t60_mySMO = temp_ay.sync_AccelerationLateral_t60_mySMO;
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_25__29.data;
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2);

% ------------------------------------------------------------------------------------------
% 把场景中数据，存储如下
myArteon = ID25Start.loadsave(loadDataS, myArteon);
myArteon = ID26Start.loadsave(loadDataS, myArteon);
myArteon = ID27Start.loadsave(loadDataS, myArteon);
myArteon = ID28Start.loadsave(loadDataS, myArteon);
myArteon = ID29Start.loadsave(loadDataS, myArteon); % id 25 - 29 数据来源于一个大场景

%%
myArteonArr = struct2array(myArteon);

save myArteon myArteon
save myArteonArr myArteonArr

disp('---------------> save over <-------------------')

time_end = datetime; disp('all time needed: '); disp(time_end - time_start);
