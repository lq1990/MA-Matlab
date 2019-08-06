%load('e:\Projekte\20170601_Geely_Performace_Quality_Evaluation\Organisatorisch\40 Messdaten\VW Arteon\Testdaten_07.02.18_dry\Vector\299-300-301-317-318-319-335-336-337.mat');

%%
n_mot_wot_vec = [1000,  1250,  1500,  1750,  2000,  2250,  2500,  2750,  3000,  3500,  4000,  4250,  5000,  5500,  6000,  6500];
m_mot_wot_vec = [200.0, 250.0, 320.0, 320.0, 320.0, 320.0, 320.0, 320.0, 320.0, 320.0, 320.0, 318.0, 270.0, 242.0, 218.0, 198.0];
% figure;
% plot(n_mot_wot_vec, m_mot_wot_vec, 'b.-', 'LineWidth', 2);
% ylim([0, 350]);
% xlim([0, 7000]);

%%
% Drehzahl
[t_n_mot_vec, n_mot_vec] = findSyncSignalWithName('CAN2_Motor_12_MO_Drehzahl_01_t524');
[t_n_mot_komb_vec, n_mot_komb_vec] = findSyncSignalWithName('CAN2_Motor_04_MO_Anzeigedrehz_t517');
[t_n_leer_soll_vec, n_leer_soll_vec] = findSyncSignalWithName('CAN2_Motor_20_MO_Solldrehz_Leerlauf_t624');

% Geschwindigkeit
[t_v_vec, v_vec] = findSyncSignalWithName('CAN2_ESP_21_ESP_v_Signal_t627');
[t_v_komb_vec, v_komb_vec] = findSyncSignalWithName('CAN2_Kombi_01_KBI_angez_Geschw_t499');
[t_v_vl_vec, v_vl_vec] = findSyncSignalWithName('CAN2_ESP_10_ESP_VL_Fahrtrichtung_t658');
[t_v_vr_vec, v_vr_vec] = findSyncSignalWithName('CAN2_ESP_10_ESP_VR_Fahrtrichtung_t658');
[t_v_hl_vec, v_hl_vec] = findSyncSignalWithName('CAN2_ESP_10_ESP_HL_Fahrtrichtung_t658');
[t_v_hr_vec, v_hr_vec] = findSyncSignalWithName('CAN2_ESP_10_ESP_HR_Fahrtrichtung_t658');

% Beschleunigung
[t_xpp_vec, xpp_vec] = findSyncSignalWithName('CAN2_ESP_02_ESP_Laengsbeschl_t656');
[t_xpp_seat_vec, xpp_seat_vec] = findSyncSignalWithName('AccelerationChassis_t25');
xpp_seat_vec = xpp_seat_vec - mean(xpp_seat_vec) + mean(xpp_vec);
[t_ypp_vec, ypp_vec] = findSyncSignalWithName('CAN2_ESP_02_ESP_Querbeschleunigung_t656');

% Pedale
[t_fp_vec, fp_vec] = findSyncSignalWithName('CAN2_Motor_20_MO_Fahrpedalrohwert_01_t527');
[t_fpp_vec, fpp_vec] = findSyncSignalWithName('CAN2_Motor_20_MO_Fahrpedalgradient_t624');
[t_dki_vec, dki_vec] = findSyncSignalWithName('CAN2_OBD_01_OBD_Abs_Throttle_Pos_t528');
[t_kd_vec, kd_vec] = findSyncSignalWithName('CAN2_Motor_14_MO_Kickdown_t19');
[t_br_vec, br_vec] = findSyncSignalWithName('CAN2_ESP_05_ESP_Bremsdruck_t648');

% Drehmoment
[t_m_mot_vec, m_mot_vec] = findSyncSignalWithName('CAN2_Motor_11_MO_Mom_Ist_Summe_t528');
[t_m_mot_schub_vec, m_mot_schub_vec] = findSyncSignalWithName('CAN2_Motor_11_MO_Mom_Schub_t524');
[t_m_mot_anf_roh_vec, m_mot_anf_roh_vec] = findSyncSignalWithName('CAN2_Motor_11_MO_Mom_Soll_Roh_t524');
[t_m_mot_anf_filt_vec, m_mot_anf_filt_vec] = findSyncSignalWithName('CAN2_Motor_11_MO_Mom_Soll_gefiltert_t524');
[t_schub_abschal_vec, schub_abschal_vec] = findSyncSignalWithName('CAN2_Motor_20_MO_Schubabschaltung_t624');
[t_m_mot_eingriff_vec, m_mot_eingriff_vec] = findSyncSignalWithName('CAN2_Getriebe_11_GE_MMom_Soll_02_t621');
[t_m_mot_eingriff_flag_vec, m_mot_eingriff_flag_vec] = findSyncSignalWithName('CAN2_Getriebe_11_GE_MMom_Status_t662');
m_mot_theo_vec = interp1(n_mot_wot_vec, m_mot_wot_vec, n_mot_vec);  % theoretisch max. Drehmoment bei vorhandener Drehzahl

% Fahrdynamik
[t_gierrate_vec, gierrate_vec] = findSyncSignalWithName('CAN2_ESP_02_ESP_Gierrate_t656');
[t_gierrate_sig_vec, gierrate_sig_vec] = findSyncSignalWithName('CAN2_ESP_02_ESP_Gierrate_t656');
[t_lenkrad_vec, lenkrad_vec] = findSyncSignalWithName('CAN6_LWI_01_LWI_Lenkradwinkel_t497');

% Getriebe
[t_n_get_in_vec, n_get_in_vec] = findSyncSignalWithName('CAN2_Getriebe_13_GE_Eingangsdrehz_t663');
[t_g_tar_vec, g_tar_vec] = findSyncSignalWithName('CAN2_Getriebe_11_GE_Zielgang_t664');
[t_mod_get_vec, mod_get_vec] = findSyncSignalWithName('CAN2_Getriebe_17_GE_Fahrprogramm_t664');
[t_ablauf_get_vec, ablauf_get_vec] = findSyncSignalWithName('CAN2_Getriebe_11_GE_Schaltablauf_t621');

% Akustik
[t_mikro_vec, mikro_vec] = findSyncSignalWithName('HBM_Mikrophon_t8');

% ACC
[t_acc_st_vec, acc_st_vec] = findSyncSignalWithName('CAN2_ACC_06_ACC_Status_ACC_t618');



%%
h = figure; 
ax1 = subplot(4, 1, 1);
hold on; grid on;
plot(t_v_vec, v_vec, 'LineWidth', 2, 'DisplayName', 'Velocity');
plot(t_fp_vec, fp_vec,'LineWidth',3, 'DisplayName', 'Acc. pedal position');
stairs(t_kd_vec, kd_vec * 90, 'g', 'DisplayName', 'Kickdown * 90');
stairs(t_acc_st_vec, acc_st_vec * 10, 'm', 'DisplayName', 'ACC state * 10');
stairs(t_g_tar_vec, g_tar_vec * 10, 'k', 'LineWidth', 1, 'DisplayName', 'Target gear * 10');
% ylim([0, 120]);
legend('show');
set(ax1, 'FontSize', 14)
title('Arteon');

ax2 = subplot(4, 1, 2);
hold on;
plot(t_xpp_seat_vec, xpp_seat_vec, 'g', 'DisplayName', 'Longitudinal acceleration sensor');
plot(t_xpp_vec, xpp_vec, 'b', 'DisplayName', 'Longitudinal acceleration');
plot(t_ypp_vec, ypp_vec, 'r', 'DisplayName', 'Lateral acceleration');
plot(t_br_vec, br_vec / 20, 'k', 'DisplayName', 'Brake pressure / 20');
legend('show');
set(ax2, 'FontSize', 14)

ax3 = subplot(4, 1, 3);
hold on;
plot(t_n_mot_vec, n_mot_vec, 'k', 'LineWidth', 2, 'DisplayName', 'Engine speed');
%plot(t_n_mot_komb_vec, n_mot_komb_vec, 'g', 'LineWidth', 1, 'DisplayName', 'displayed engine speed');
plot(t_n_get_in_vec, n_get_in_vec, 'r', 'DisplayName', 'Transmission input speed');
stairs(t_ablauf_get_vec, ablauf_get_vec * 1000, 'k', 'LineWidth', 1, 'DisplayName', 'Schaltablauf * 1000');
ylim([0, 6000]);
legend('show');
set(ax3, 'FontSize', 14)

ax4 = subplot(4, 1, 4);
hold on;
plot(t_m_mot_vec, m_mot_vec, 'b', 'DisplayName', 'Engine torque');
plot(t_n_mot_vec, m_mot_theo_vec, 'k:', 'LineWidth', 1, 'DisplayName', 'Theo. engine torque');
plot(t_m_mot_anf_roh_vec, m_mot_anf_roh_vec, 'r', 'DisplayName', 'Raw demanded torque');
plot(t_m_mot_anf_filt_vec, m_mot_anf_filt_vec, 'g', 'DisplayName', 'Filtered demanded torque');
plot(t_m_mot_eingriff_vec, m_mot_eingriff_vec, 'm', 'DisplayName', 'Requested torque reduction');
stairs(t_m_mot_eingriff_flag_vec, m_mot_eingriff_flag_vec * 100, 'c', 'DisplayName', 'Requested torque reduction flag * 100');
stairs(t_schub_abschal_vec, schub_abschal_vec * 100, 'k', 'DisplayName', 'Schubabschaltung * 100');
% plot(t_m_rad_l_vec, m_rad_l_vec / 14, 'DisplayName', 'Left half shaft torque');
xlabel('Time [s]');
legend('show');
set(ax4, 'FontSize', 14)

linkaxes([ax1, ax2, ax3, ax4], 'x');

dcmObj = datacursormode(h);
set(dcmObj, 'UpdateFcn', @myUpdateFcn, 'Enable', 'off');


%% Mikroschlupf
return;
if numel(n_mot_vec) ~= numel(n_get_in_vec)
    n_get_itp_vec = interp1(t_n_get_in_vec, n_get_in_vec, t_n_mot_vec);
else
    n_get_itp_vec = n_get_in_vec;
end

h = figure; 
ax1 = subplot(3, 1, 1);
hold on;
plot(t_n_mot_vec, n_mot_vec, 'k', 'LineWidth', 2, 'DisplayName', 'Engine speed');
plot(t_n_get_in_vec, n_get_in_vec, 'r', 'DisplayName', 'Transmission input speed');
ylim([0, 6000]);
legend('show');
set(ax1, 'FontSize', 14)
title('Arteon');

ax2 = subplot(3, 1, 2);
hold on;
plot(t_n_mot_vec, n_mot_vec - n_get_itp_vec, 'r', 'LineWidth', 1, 'DisplayName', 'Mikroschlupf');
ylim([-500, 500]);
legend('show');
set(ax2, 'FontSize', 14)
title('Mikroschlupf');

ax3 = subplot(3, 1, 3);
hold on;
plot(t_v_vec, v_vec, 'LineWidth', 2, 'DisplayName', 'Velocity');
plot(t_fp_vec, fp_vec, 'DisplayName', 'Acc. pedal position');
stairs(t_kd_vec, kd_vec * 90, 'g', 'DisplayName', 'Kickdown * 90');
stairs(t_g_tar_vec, g_tar_vec * 10, 'k', 'LineWidth', 1, 'DisplayName', 'Target gear * 10');
legend('show');
set(ax3, 'FontSize', 14)

linkaxes([ax1, ax2, ax3], 'x');

dcmObj = datacursormode(h);
set(dcmObj, 'UpdateFcn', @myUpdateFcn, 'Enable', 'off');



