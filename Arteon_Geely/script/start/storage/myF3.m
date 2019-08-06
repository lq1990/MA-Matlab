clc
clear
close all
%% signal generate
Fs = 500;
Ts = 1/Fs;
t = 0:Ts:1-Ts;

f1 = 5;
f2 = 40;
f3 = 100;

y = 5*sin(2*pi*f1*t) +  2*sin(2*pi*f2*t) +  1*sin(2*pi*f3*t); 

figure;
plot(t,y);
grid on;

%% fft
nfft = length(y);
nfft2 = 2.^nextpow2(nfft);

fy = fft(y, nfft2);
fy = fy(1: nfft2/2);
xfft = Fs.* (0: nfft2/2 -1)/nfft2;
figure;
plot(xfft, abs(fy/max(fy)));

%% fir filter
cut_off = 10 / Fs/2;
order = 32;
h = fir1(order, cut_off);

fh = fft(h, nfft2);
fh = fh(1: nfft2/2);

mul = fy.*fh;
con = conv(y,h);

figure; 
subplot(321)
plot(xfft, abs(fy/max(fy))); grid on;
subplot(323)
plot(xfft, abs(fh/max(fh)));
subplot(325)
plot(abs(mul/max(mul)));

subplot(322)
plot(t, y); grid on;
subplot(324)
plot(t, con(1+order/2: end-order/2)); grid on;



