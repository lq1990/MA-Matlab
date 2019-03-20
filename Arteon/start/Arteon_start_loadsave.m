% Arteon 起步
clear; clc; close all;

addpath myClasses
addpath scenarioClasses
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

save tempData  % 此处save，为了 在 scenarioClasses中再去load使用

% 把所有场景对应的数据存储，进行如下
% 问题：每一个类都要重新load数据，能否把 tempData做成单例，所有类共享。======================
myArteon = struct; % init一个空struct
myArteon = ID16Start.loadsave('tempData.mat', myArteon);
myArteon = ID17Start.loadsave('tempData.mat', myArteon);
myArteon = ID18Start.loadsave('tempData.mat', myArteon); 
% id 16 17 18 数据来源于一个大场景，因此只需要load一次数据，可实际上在三个类中各自都load了一次，改进？！


%% load start(2) id: 25, 26, 27, 28, 29
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');
load('.\id_25_26_27_28_29\sync_AccelerationLateral_t60_mySMO.mat');
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
my_acc_pedal = acc_pedal_25__29.data;

save tempData

% 把场景中数据，存储如下
myArteon = ID25Start.loadsave('tempData.mat', myArteon);
myArteon = ID26Start.loadsave('tempData.mat', myArteon);
myArteon = ID27Start.loadsave('tempData.mat', myArteon);
myArteon = ID28Start.loadsave('tempData.mat', myArteon);
myArteon = ID29Start.loadsave('tempData.mat', myArteon); % id 25 - 29 数据来源于一个大场景

%%
% struct2array
myArteonArr = struct2array(myArteon);

% save
save myArteon myArteon
save myArteonArr myArteonArr


delete('tempData.mat');
disp('---------------> save over <-------------------')
