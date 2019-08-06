%
clc; clear; close all;

%
ds = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');

ay = ds.sync_CAN2_ESP_02_ESP_Laengsbeschl_t20;




%% my，线性

factor = 10; % 扩展几倍

ay_new = zeros(2, 1); % init 列向量
for i = 1:length(ay)
    if i==1
        ay_new(1) = ay(1);
        continue
    end
    
    i_new = (i-1)*factor +1;
    
    for j = 1:factor
        ay_new(i_new-(factor-j)) = ( ay(i)-ay(i-1) ) / factor * j +ay(i-1);
    end
    
end

%
figure;
clf;
subplot(211)
plot(ay,'.'); grid on;
xlim([1, 10000]);

subplot(212)
plot(ay_new, '.'); grid on;
xlim([1, 10000*factor]);





%% interp1 % 太慢了
% x = 1:length(ay);
% y_all = [];
% for xi = 1:0.01:length(ay)
%     if mod(xi,100) == 0
%         disp(xi);
%     end
%     
%     yi= interp1(x, ay, xi);
%     y_all = [y_all, yi];
%     
% end


