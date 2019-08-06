clc
clear
close all
%% 
Fs = 100e1; % 采样频率
Ts = 1/Fs;
t = 0:Ts:1 -Ts;

f1 = 1e1;
f2 = 5e1;
f3 = 10e1;

y = 10 * sin(2*pi*f1*t) + 2 * sin(2*pi*f2*t) + 1 * sin(2*pi*f3*t) ; % DIY生成信号

% figure(1);
% plot(t,y); grid on;
% title('time domain')
% xlabel('time [s]')
% ylabel('amp')

%% fft

nfft = length(y);
nfft2 = 2.^nextpow2(nfft);
fy = fft(y, nfft2);
fy = fy(1: nfft2/2);
xfft = Fs.*(0: nfft2/2 -1) / nfft2;
figure(2)
% plot(xfft, abs(fy/ max(fy)  )); grid on;
% title('frequency domain')
% xlabel('Hz')
% ylabel('amp')

%% low pass filter，使用 fir 滤波器
cut_off = 20 / Fs/2;  % 模拟频率20 转为 数字频率
order = 30;

h = fir1(order, cut_off);

freqz(h) % plot 滤波器响应，频谱图
%

fh = fft(h, nfft2);
fh = fh(1: nfft2/2);

mul = fh.*fy;

con = conv(y, h);

figure(3)
subplot(321)
plot(xfft, abs(fh / max(fh) )); grid on;
title('plot(xfft, abs(fh / max(fh) ));');

subplot(323)
plot( abs(mul/ max(mul)) ); grid on;
title('abs(mul/ max(mul)) ');

subplot(322)
plot(t, con(1+order/2: end-order/2)  ); grid on; % t 和 con length不同。得到的con应该去除前面的一小部分，使得和原数据同步。
title('conv(y,h )');



subplot(324)
plot(t, y); grid on;
title('original y-t')

subplot(325)
plot(xfft, abs(fy/ max(fy)  )); grid on;
title('frequency domain')
xlabel('Hz')
ylabel('amp')




