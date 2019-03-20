clc
clear 
close all
%%
Fs = 300;
Ts = 1/Fs;
t = 0:Ts:1-Ts;

f1 = 5;
f2 = 20;
f3 = 30;

y = 10*sin(2*pi*f1*t) + 1*sin(2*pi*f2*t) + 1*sin(2*pi*f3*t);
figure(1);
subplot(211)
plot(t,y); grid on;
title('original, time domain');

%% fft analyse
nfft = length(y);
nfft2 = 2.^nextpow2(nfft);

fy = fft(y,nfft2);
fy = fy(1: nfft2/2);
xfft = Fs.*(0: nfft2/2 - 1)/nfft2;
figure(2);
plot(xfft,abs( fy/max(fy)));

%% filter
cut_off = 10 / Fs/2;
order = 12;
h = fir1(order, cut_off);

freqz(h)

con = conv(y,h);
figure(1);
subplot(212)
plot(t, con(1+order/2: end-order/2)); grid on;
title('after filtering');