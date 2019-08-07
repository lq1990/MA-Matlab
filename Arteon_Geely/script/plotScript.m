clear; clc; close all;

load D:\MA\Daten\Messdaten\Messdaten_Geely\Messdaten_16.05.18_dry_wet\Syncdaten\149-150_sync.mat

%% Arteon
% close all;
% 
% figure;
% plot(sync_t5, sync_CAN2_Motor_12_MO_Drehzahl_01_t5); % EngineSpeed
% hold on; grid on;
% plot(sync_t2, sync_CAN2_Getriebe_11_GE_Schaltablauf_t2* 500); % ShiftProcess
% plot(sync_t3, sync_CAN2_Getriebe_11_GE_Zielgang_t3*1000, 'k', 'LineWidth', 2); % TargetGear
% 
% title('Arteon');
% legend('n motor', 'schaltablauf', 'targetGear');

% t_max = max(sync_t5);
% set(gca,'XTick',0:1:t_max);

%% Geely
close all;

figure;
plot(sync_t4, sync_EMS_EngineSpeedRPM_t4); % EngineSpeed
hold on; grid on;
plot(sync_t24, sync_TCU_GearShiftInProgress_t24* 5000); % ShiftInProgress
plot(sync_t13, sync_TCU_TargetGearReq_t13*1000, 'k', 'LineWidth', 2); % TargetGear

title('Geely');
legend('EngineSpeed', 'ShiftInProgress', 'TargetGear');

