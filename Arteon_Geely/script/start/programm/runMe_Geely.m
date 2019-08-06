%% Geely Messdaten-Auswertung
% load('E:\Projekte\20170601_Geely_Performace_Quality_Evaluation\Organisatorisch\40 Messdaten\Geely\2018.05.16_Kupplungtest_Chen_Ren\Vector\03 L635.mat');
%load('e:\Projekte\20170601_Geely_Performace_Quality_Evaluation\Organisatorisch\40 Messdaten\Geely\2018.05.16_Kupplungtest_Chen_Ren\Vector\02 test bevenrode.mat');

%%
n_mot_wot_vec = [1000,  1250,  1500,  1750,  2000,  2250,  2500,  2750,  3000,  3500,  4000,  4500,  5000];
m_mot_wot_vec = [177.1, 222.0, 284.4, 302.6, 302.2, 299.1, 302.1, 301.8, 302.3, 302.5, 300.8, 276.8, 253.0];

%%
% Drehzahl
[t_n_mot_vec, n_mot_vec] = findSyncSignalWithName('EMS_EngineSpeedRPM_t5');
[t_n_leer_soll_vec, n_leer_soll_vec] = findSyncSignalWithName('EMS_TargetIdlespeed_t7');

% Geschwindigkeit
[t_v_vec, v_vec] = findSyncSignalWithName('ESP_VehicleSpeed_t11');

% Beschleunigung
[t_xpp_vec, xpp_vec] = findSyncSignalWithName('YRS_LongitAcce_t23');
[t_xpp_seat_vec, xpp_seat_vec] = findSyncSignalWithName('AccelerationChassis_t25');
[t_ypp_vec, ypp_vec] = findSyncSignalWithName('YRS_LateralAcce_t22');

% Pedale
[t_fp_vec, fp_vec] = findSyncSignalWithName('EMS_AccelPedalPosition_t5');
[t_dki_vec, dki_vec] = findSyncSignalWithName('EMS_ThrottlePosition_t5');
[t_kd_vec, kd_vec] = findSyncSignalWithName('EMS_Kickdown_t7');
[t_br_vec, br_vec] = findSyncSignalWithName('ESP_Mcylinder_Pressure_t11');
[t_br_pressed_vec, br_pressed_vec] = findSyncSignalWithName('EMS_BrakeStatus_t7');

% Drehmoment
[t_m_mot_vec, m_mot_vec] = findSyncSignalWithName('EMS_ActualEngineTorque_t7');
[t_m_mot_anf_filt_vec, m_mot_anf_filt_vec] = findSyncSignalWithName('EMS_EngineTorqueWOTCUReq_t6');
[t_schub_abschal_vec, schub_abschal_vec] = findSyncSignalWithName('EMS_EngFuelCutActive_t6');
[t_m_mot_eingriff_vec, m_mot_eingriff_vec] = findSyncSignalWithName('TCU_FastTorqueReductionReq_t21');
[t_m_mot_eingriff_flag_vec, m_mot_eingriff_flag_vec] = findSyncSignalWithName('TCU_EngTrqReqFlag_t21');
[t_m_rad_links_vec, m_rad_links_vec] = findSyncSignalWithName('Drehmoment_links_t55');
    m_rad_links_vec(abs(m_rad_links_vec)>20000) = NaN;
[t_m_rad_rechts_vec, m_rad_rechts_vec] = findSyncSignalWithName('Drehmoment_rechts_t56');
    m_rad_rechts_vec(abs(m_rad_rechts_vec)>20000) = NaN;
m_mot_theo_vec = interp1(n_mot_wot_vec, m_mot_wot_vec, n_mot_vec);  % theoretisch max. Drehmoment bei vorhandener Drehzahl

% Fahrdynamik
[t_gierrate_vec, gierrate_vec] = findSyncSignalWithName('YRS_YawRate_t22');
[t_lenkrad_vec, lenkrad_vec] = findSyncSignalWithName('SAS_SteerWheelAngle_t17');

% Getriebe
[t_n_get_1_vec, n_get_1_vec] = findSyncSignalWithName('TCU_InputShaftOddSpeed_t20');
[t_n_get_2_vec, n_get_2_vec] = findSyncSignalWithName('TCU_InputShaftEvenSpeed_t20');
[t_g_tar_vec, g_tar_vec] = findSyncSignalWithName('TCU_TargetGearReq_t18');
    g_tar_vec(g_tar_vec==10) = -2;  % Park
    g_tar_vec(g_tar_vec==11) = -1;  % Rückwärts
[t_g_cur_vec, g_cur_vec] = findSyncSignalWithName('TCU_CurrentGearPosition_t18');
    g_cur_vec(g_cur_vec==10) = -2;  % Park
    g_cur_vec(g_cur_vec==11) = -1;  % Rückwärts
[t_mod_get_vec, mod_get_vec] = findSyncSignalWithName('TCU_TGSMode_t19');
[t_sip_get_vec, sip_get_vec] = findSyncSignalWithName('TCU_GearShiftInProgress_t18');
[t_shift_sup_vec, shift_sup_vec] = findSyncSignalWithName('ESP_GearShiftInhibit_t11');
[t_state_ku_1_vec, state_ku_1_vec] = findSyncSignalWithName('TCU_ClutchOddState_t18');      % 2: closed, 1: slipping, 0: open
[t_state_ku_2_vec, state_ku_2_vec] = findSyncSignalWithName('TCU_ClutchEvenState_t18');

% Akustik
[t_mikro_vec, mikro_vec] = findSyncSignalWithName('Mikrophon_t31');

% ACC
[t_acc_st_vec, acc_st_vec] = findSyncSignalWithName('EMS_CruiseControlSts_t7');


%% 
h = figure; 
num_subplot = 5;
fontsize_legend = 7;
ax1 = subplot(num_subplot, 1, 1);
hold on;
plot(t_v_vec, v_vec, 'LineWidth', 2, 'DisplayName', 'Velocity');
plot(t_fp_vec, fp_vec, 'DisplayName', 'Acc. pedal position');
stairs(t_kd_vec, kd_vec * 90, 'g', 'DisplayName', 'Kickdown * 90');
stairs(t_acc_st_vec, acc_st_vec * 10, 'm', 'DisplayName', 'ACC state * 10');
stairs(t_g_tar_vec, g_tar_vec * 10, 'g', 'LineWidth', 1, 'DisplayName', 'Target gear * 10');
stairs(t_g_cur_vec, g_cur_vec * 10, 'k', 'LineWidth', 1, 'DisplayName', 'Current gear * 10');
% ylim([0, 100]);
lg = legend('show');
lg.FontSize = fontsize_legend;
set(ax1, 'FontSize', 14)
title('Geely');

ax2 = subplot(num_subplot, 1, 2);
hold on;
plot(t_xpp_seat_vec, xpp_seat_vec * 9.81 / 10, 'g', 'DisplayName', 'Longitudinal acceleration sensor');
plot(t_xpp_vec, xpp_vec * 9.81, 'b', 'DisplayName', 'Longitudinal acceleration');
% plot(t_ypp_vec, ypp_vec * 9.81, 'r', 'DisplayName', 'Lateral acceleration');
%plot(t_br_vec, br_vec * 5, 'k', 'DisplayName', 'Brake pressure * 5');
stairs(t_br_pressed_vec, br_pressed_vec, 'k', 'DisplayName', 'Brake pressed');
lg = legend('show');
lg.FontSize = fontsize_legend;
set(ax2, 'FontSize', 14)

ax3 = subplot(num_subplot, 1, 3);
hold on;
plot(t_n_mot_vec, n_mot_vec, 'k', 'LineWidth', 2, 'DisplayName', 'Engine speed');
plot(t_n_get_1_vec, n_get_1_vec, 'r', 'DisplayName', 'Transmission input speed odd');
plot(t_n_get_2_vec, n_get_2_vec, 'g', 'DisplayName', 'Transmission input speed even');
stairs(t_sip_get_vec, sip_get_vec * 1000, 'k--', 'LineWidth', 1, 'DisplayName', 'Shift in progress * 1000');
stairs(t_shift_sup_vec, shift_sup_vec * 500, 'm', 'LineWidth', 1, 'DisplayName', 'Shift supressed * 500');
ylim([0, 6000]);
lg = legend('show');
lg.FontSize = fontsize_legend;
set(ax3, 'FontSize', 14)

ax4 = subplot(num_subplot, 1, 4);
hold on;
plot(t_m_mot_vec, m_mot_vec, 'b', 'LineWidth', 2, 'DisplayName', 'Engine torque');
plot(t_n_mot_vec, m_mot_theo_vec, 'k:', 'LineWidth', 1, 'DisplayName', 'Theo. engine torque');
plot(t_m_mot_anf_filt_vec, m_mot_anf_filt_vec, 'g', 'DisplayName', 'Filtered demanded torque');
plot(t_m_mot_eingriff_vec, m_mot_eingriff_vec, 'm', 'DisplayName', 'Requested torque reduction');
stairs(t_schub_abschal_vec, schub_abschal_vec * 200, 'k', 'DisplayName', 'Engine fuel cut * 200');
stairs(t_m_mot_eingriff_flag_vec, m_mot_eingriff_flag_vec * 100, 'c', 'DisplayName', 'Requested torque reduction flag * 100');
% plot(t_m_rad_l_vec, m_rad_l_vec / 14, 'DisplayName', 'Left half shaft torque');
stairs(t_state_ku_1_vec, state_ku_1_vec * 50, 'r--', 'DisplayName', 'Clutch odd status * 50');    % 0: open, 1: slipping, 2: closed, 3: invalid
stairs(t_state_ku_2_vec, state_ku_2_vec * 50, 'g--', 'DisplayName', 'Clutch even status * 50');   % 0: open, 1: slipping, 2: closed, 3: invalid
xlabel('Time [s]', 'FontSize', 14);
lg = legend('show');
lg.FontSize = fontsize_legend;
set(ax4, 'FontSize', 14)

ax5 = subplot(num_subplot, 1, 5);
hold on;
% plot(t_m_rad_rechts_vec, m_rad_rechts_vec, 'm', 'LineWidth', 1, 'DisplayName', 'Right wheel torque');
plot(t_m_rad_links_vec, m_rad_links_vec, 'b', 'LineWidth', 1, 'DisplayName', 'Left wheel torque');
lg = legend('show');
lg.FontSize = fontsize_legend;
set(ax5, 'FontSize', 14)


if num_subplot==4
    linkaxes([ax1, ax2, ax3, ax4], 'x');
elseif num_subplot==5
    linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');
end

dcmObj = datacursormode(h);
set(dcmObj, 'UpdateFcn', @myUpdateFcn, 'Enable', 'off');


%% Mikroschlupf
return;
if numel(n_mot_vec) ~= numel(n_get_1_vec) || numel(n_mot_vec) ~= numel(n_get_2_vec)
    n_get_1_itp_vec = interp1(t_n_get_1_vec, n_get_1_vec, t_n_mot_vec);
    n_get_2_itp_vec = interp1(t_n_get_2_vec, n_get_2_vec, t_n_mot_vec);
else
    n_get_1_itp_vec = n_get_1_vec;
    n_get_2_itp_vec = n_get_2_vec;
end

h = figure; 
ax1 = subplot(3, 1, 1);
hold on;
plot(t_n_mot_vec, n_mot_vec, 'k', 'LineWidth', 2, 'DisplayName', 'Engine speed');
plot(t_n_get_1_vec, n_get_1_vec, 'r', 'DisplayName', 'Transmission input speed odd');
plot(t_n_get_2_vec, n_get_2_vec, 'g', 'DisplayName', 'Transmission input speed even');
ylim([0, 6000]);
legend('show');
set(ax1, 'FontSize', 14)
title('Geely');

ax2 = subplot(3, 1, 2);
hold on;
plot(t_n_mot_vec, n_mot_vec - n_get_1_itp_vec, 'r', 'LineWidth', 1, 'DisplayName', 'Mikroschlupf K1');
plot(t_n_mot_vec, n_mot_vec - n_get_2_itp_vec, 'g', 'LineWidth', 1, 'DisplayName', 'Mikroschlupf K2');
ylim([-500, 500]);
legend('show');
set(ax2, 'FontSize', 14)
title('Mikroschlupf');

ax3 = subplot(3, 1, 3);
hold on;
plot(t_v_vec, v_vec, 'LineWidth', 2, 'DisplayName', 'Velocity');
plot(t_fp_vec, fp_vec, 'DisplayName', 'Acc. pedal position');
stairs(t_kd_vec, kd_vec * 90, 'g', 'DisplayName', 'Kickdown * 90');
stairs(t_g_tar_vec, g_tar_vec * 10, 'm', 'LineWidth', 1, 'DisplayName', 'Target gear * 10');
stairs(t_g_cur_vec, g_cur_vec * 10, 'k', 'LineWidth', 1, 'DisplayName', 'Current gear * 10');
legend('show');
set(ax3, 'FontSize', 14)

linkaxes([ax1, ax2, ax3], 'x');

dcmObj = datacursormode(h);
set(dcmObj, 'UpdateFcn', @myUpdateFcn, 'Enable', 'off');











