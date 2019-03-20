% Arteon ��
clear; clc; close all;

addpath myClasses
addpath scenarioClasses
%% ================= 25 #important KP ===========================
% 01. engine speed          14. vehicle speed       16. Longitudinal acceleration  17. Lateral acceleration
% 20. Acc. pedal position  21. Throttle position  23. Kickdown                          24. Engine torque
% 32. Transmission input speed   33. Transmission input speed odd gears
% 34. Transmission input speed even gears
%% load start(1) id: 16, 17, 18
% 16��17, 18�������� ͬһ�����Ի����£����һ��ʱ�� ���� 3�Ρ�
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');
load('.\id_16_17_18\sync_AccelerationLateral_t60_mySMO.mat');
% load 16_17_18, AcceleratorPedal.txt
acc_pedal_16_17_18 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\16-17-18\AcceleratorPedal.txt');
my_acc_pedal = acc_pedal_16_17_18.data;

save tempData  % �˴�save��Ϊ�� �� scenarioClasses����ȥloadʹ��

% �����г�����Ӧ�����ݴ洢����������
% ���⣺ÿһ���඼Ҫ����load���ݣ��ܷ�� tempData���ɵ����������๲��======================
myArteon = struct; % initһ����struct
myArteon = ID16Start.loadsave('tempData.mat', myArteon);
myArteon = ID17Start.loadsave('tempData.mat', myArteon);
myArteon = ID18Start.loadsave('tempData.mat', myArteon); 
% id 16 17 18 ������Դ��һ���󳡾������ֻ��Ҫloadһ�����ݣ���ʵ�������������и��Զ�load��һ�Σ��Ľ�����


%% load start(2) id: 25, 26, 27, 28, 29
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\25-26-27-28-29_sync.mat');
load('.\id_25_26_27_28_29\sync_AccelerationLateral_t60_mySMO.mat');
acc_pedal_25__29 = importdata('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\AVL_Drive\25-26-27-28-29\AcceleratorPedal.txt');
my_acc_pedal = acc_pedal_25__29.data;

save tempData

% �ѳ��������ݣ��洢����
myArteon = ID25Start.loadsave('tempData.mat', myArteon);
myArteon = ID26Start.loadsave('tempData.mat', myArteon);
myArteon = ID27Start.loadsave('tempData.mat', myArteon);
myArteon = ID28Start.loadsave('tempData.mat', myArteon);
myArteon = ID29Start.loadsave('tempData.mat', myArteon); % id 25 - 29 ������Դ��һ���󳡾�

%%
% struct2array
myArteonArr = struct2array(myArteon);

% save
save myArteon myArteon
save myArteonArr myArteonArr


delete('tempData.mat');
disp('---------------> save over <-------------------')
