clear; clc; close all;

load D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_21.02.18_dry\Syncdaten\148-347_sync.mat

%%
close all;
t_max = max(sync_t5);

figure;
plot(sync_t5, sync_CAN2_Motor_12_MO_Drehzahl_01_t5); 
hold on; grid on;
plot(sync_t2, sync_CAN2_Getriebe_11_GE_Schaltablauf_t2* 500);
plot(sync_t3, sync_CAN2_Getriebe_11_GE_Zielgang_t3*1000, 'k', 'LineWidth', 2);

title('Arteon');
legend('n motor', 'schaltablauf', 'targetGear');
% set(gca,'XTick',0:1:t_max);


