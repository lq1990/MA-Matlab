clc
clear
close all

%% DIYÐÅºÅ
Fs = 500;
Ts = 1/Fs;
t = 0:Ts:1-Ts;

f1 = 5;
f2 = 50;
f3 = 100;

y = 5*sin(2*pi*f1*t) + 2 *sin(2*pi*f2*t) + 1*sin(2*pi*f3*t);

% figure;
% plot(t, y);
%% fft
nfft = length(y);
nfft2 = 2.^nextpow2(nfft);

fy = fft(y, nfft2);
fy = fy(1: nfft2/2 );

xfft = Fs.* (0: nfft2/2 -1 ) / nfft2;
% 
% figure;
% plot(xfft, abs(fy/max(fy))); grid on;

%% fir filter
cut_off = 10 /Fs/2;
order = 32;
h = fir1(order, cut_off);
fh = fft(h, nfft2);
fh = fh(1: nfft2/2);

mul = fy.*fh;
con = conv(y, h);

figure;
subplot(321)
plot(xfft, abs(fy/max(fy))); grid on;
title('frequency domain');
subplot(323)
plot(xfft, abs(fh/max(fh))); grid on;
title('filter');
xlabel('Hz');
subplot(325)
plot(abs(mul/max(mul))); grid on;
title('frequency domain, after filtering') ;

subplot(322)
plot(t,y); grid on;
title('original, time domain, y-t');
subplot(324)
plot(t, con(1+order/2 : end-order/2)); grid on;





