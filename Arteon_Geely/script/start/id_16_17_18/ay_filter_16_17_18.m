clear
close all
clc
%%
load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');

%%
ay_t60 = sync_AccelerationLateral_t60;
len = length(ay_t60);
t = 1:len;

figure(1);
subplot(221)
plot(t, ay_t60); grid on;
title('original time domain');
% fft
nfft = length(ay_t60);
nfft2 = 2.^nextpow2(nfft);
fy = fft(ay_t60, nfft2);
fy = fy(1: nfft2/2);
Fs = 100;
xfft = Fs.*(0: nfft2/2 -1) / nfft2;

subplot(222);
plot(xfft, abs(fy/max(fy))); grid on;
title('fft')

% filer
cut_off = 13 / Fs/2;
order = 16;
h = fir1(order, cut_off);

% figure(11)
% plot(h);

fh = fft(h, nfft2);
fh = fh(1: nfft2/2);
subplot(224)
plot(xfft, abs(fh/max(fh))); grid on;
xlabel('Hz')
title('filter')

con = conv(ay_t60,h);
figure(1);
subplot(223);
plot(t, con(1+order/2: end-order/2)); grid on;

%% save con(1+order/2: end-order/2)
con_clip = con(1+order/2: end-order/2);
my_ay = con_clip;
save my_ay my_ay


