% Arteon ��
clear; clc; close all;

time_start = datetime;

addpath(genpath(pwd)); % ���������Ŀ¼

%% ================= 25 #important KP ===========================
% 01. engine speed          14. vehicle speed       16. Longitudinal acceleration  17. Lateral acceleration
% 20. Acc. pedal position  21. Throttle position  23. Kickdown                          24. Engine torque
% 32. Transmission input speed   33. Transmission input speed odd gears
% 34. Transmission input speed even gears

%% load start(1) id: 16, 17, 18
% 16��17, 18�������� ͬһ�����Ի����£����һ��ʱ�� ���� 3�Ρ�
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');

% -------------- ԭʼ���ݲ�����Ҫ�� ������Ҫ filtered, extended ------------------
temp_ay = load('.\id_16_17_18\sync_AccelerationLateral_t60_mySMO.mat');
loadDataS.sync_AccelerationLateral_t60_mySMO = temp_ay.sync_AccelerationLateral_t60_mySMO;
acc_pedal_16_17_18 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\16-17-18\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_16_17_18.data;
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2); % Transmission input speed

% -------------------------------------------------------------------------------------
% �����г�����Ӧ�������Ѿ�Ԥ�ȴ������洢���ٽ�������
myArteon = struct; % initһ����struct
myArteon = ID16Start.loadsave(loadDataS, myArteon);
myArteon = ID17Start.loadsave(loadDataS, myArteon);
myArteon = ID18Start.loadsave(loadDataS, myArteon); 
% id 16 17 18 ������Դ��һ���󳡾������ֻ��Ҫloadһ�����ݣ���ʵ�������������и��Զ�load��һ�Σ��Ľ�����������������

%% load start(2) id: 25, 26, 27, 28, 29
loadDataS = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');

% -------------- ԭʼ���ݲ�����Ҫ�� ������Ҫ filtered, extended ------------------
temp_ay = load('.\id_25_26_27_28_29\sync_AccelerationLateral_t60_mySMO.mat');
loadDataS.sync_AccelerationLateral_t60_mySMO = temp_ay.sync_AccelerationLateral_t60_mySMO;
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
loadDataS.my_acc_pedal = acc_pedal_25__29.data;
loadDataS.my_transmission_input_speed = extendArr( loadDataS.sync_CAN2_Getriebe_13_GE_Eingangsdrehz_t8, 2);

% ------------------------------------------------------------------------------------------
% �ѳ��������ݣ��洢����
myArteon = ID25Start.loadsave(loadDataS, myArteon);
myArteon = ID26Start.loadsave(loadDataS, myArteon);
myArteon = ID27Start.loadsave(loadDataS, myArteon);
myArteon = ID28Start.loadsave(loadDataS, myArteon);
myArteon = ID29Start.loadsave(loadDataS, myArteon); % id 25 - 29 ������Դ��һ���󳡾�

%%
myArteonArr = struct2array(myArteon);

save myArteon myArteon
save myArteonArr myArteonArr

disp('---------------> save over <-------------------')

time_end = datetime; disp('all time needed: '); disp(time_end - time_start);
