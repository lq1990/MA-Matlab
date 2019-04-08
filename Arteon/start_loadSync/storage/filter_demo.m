clear;
close all;
clc;

%%
Fs = 200; % ²ÉÑùÆµÂÊ
Ts = 1/Fs;
t = 0: Ts: 1-Ts;

f1 = 5;
f2 = 20;
f3 = 50;

y = 10*sin(2*pi*f1*t) + 5*sin(2*pi*f2*t) + 2*sin(2*pi*f3*t);

figure;
subplot(221)
plot(t,y); grid on;
title('y-t, original');

%% fft
nfft = length(y);
nfft2 = 2.^nextpow2(nfft);

fy = fft(y, nfft2);
fy = fy(1: nfft2/2);
xfft = Fs.*(0: nfft2/2-1) / nfft2;

subplot(222)
plot(xfft, abs(fy/max(fy))); grid on;
title('frequency domain, original');

%% filter
cut_off = 10 / Fs/2;
order = 12;
h = fir1(order, cut_off);
fh = fft(h, nfft2);
fh = fh(1: nfft2/2);
subplot(224)
plot(xfft, abs(fh/max(fh))); grid on;
title('filter');
% freqz(h);
%%
con = conv(y,h);
subplot(223)
plot(t,con(1+order/2 : end-order/2)); grid on;
title('y-t, after filtering');

