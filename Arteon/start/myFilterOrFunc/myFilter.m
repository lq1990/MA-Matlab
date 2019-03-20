% �Ժ������������ݽ��� ��ͨ�˲�����ֹƵ����Ϊ 13-15 Hz
clc;
clear;
close all;
%%
Fs = 200e3; % ����Ƶ�� > 2*�ź�Ƶ��
Ts = 1/Fs;
dt = 0:Ts:5e-3-Ts;

f1 = 1e3;  % ��ʵ�ϣ����ǲ�֪�� Ƶ����Ϣ
f2 = 20e3;
f3 = 30e3;

y = 5*sin(2*pi*f1*dt) + 2*sin(2*pi*f2*dt) + 1*sin(2*pi*f3*dt);

% figure;
% plot(dt,y)
%%
nfft = length(y);
nfft2 = 2.^nextpow2(nfft); % �ҵ��� nfft���������2��ָ������

fy = fft(y, nfft2);
fy = fy(1:nfft2/2); % ����2����Ϊ��������ֻ��ע���һ��

xfft = Fs .*( 0 : nfft2 / 2 - 1 ) / nfft2;

% figure;
% plot(xfft, abs(fy/max(fy)));
%% low pass filter
% ȷ�� cut off frequency

cut_off = 1.5e3 / Fs/2;  % ��ֹƵ�� 1.5e3
order = 30; % order Խ��Խƽ��

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

