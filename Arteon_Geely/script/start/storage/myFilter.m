% 对含有噪声的数据进行 低通滤波，截止频率设为 13-15 Hz
clc;
clear;
close all;
%%
Fs = 200e3; % 采样频率 > 2*信号频率
Ts = 1/Fs;
dt = 0:Ts:5e-3-Ts;

f1 = 1e3;  % 事实上，我们不知道 频率信息
f2 = 20e3;
f3 = 30e3;

y = 5*sin(2*pi*f1*dt) + 2*sin(2*pi*f2*dt) + 1*sin(2*pi*f3*dt);

% figure;
% plot(dt,y)
%%
nfft = length(y);
nfft2 = 2.^nextpow2(nfft); % 找到离 nfft后面最近的2的指数数据

fy = fft(y, nfft2);
fy = fy(1:nfft2/2); % 除以2，因为镜像，我们只关注左边一半

xfft = Fs .*( 0 : nfft2 / 2 - 1 ) / nfft2;

% figure;
% plot(xfft, abs(fy/max(fy)));
%% low pass filter
% 确定 cut off frequency

cut_off = 1.5e3 / Fs/2;  % 截止频率 1.5e3
order = 30; % order 越大，越平滑

h = fir1(order, cut_off);
fh = fft(h, nfft2);
fh = fh(1:nfft2/2);

mul = fh.*fy;

figure;
subplot(3,2,2)
plot(xfft, abs(fy/max(fy)));

subplot(3,2,4)
plot(xfft, abs(fh/max(fh)));

subplot(3,2,6)
plot(abs(mul/max(mul)));

subplot(3,2,1)
plot(dt,y);
subplot(3,2,3)
stem(h)

con=conv(y, h);
subplot(3,2,5)
plot(con)

