clc
clear
close all
%% 
Fs = 100e1; % ����Ƶ��
Ts = 1/Fs;
t = 0:Ts:1 -Ts;

f1 = 1e1;
f2 = 5e1;
f3 = 10e1;

y = 10 * sin(2*pi*f1*t) + 2 * sin(2*pi*f2*t) + 1 * sin(2*pi*f3*t) ; % DIY�����ź�

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

%% low pass filter��ʹ�� fir �˲���
cut_off = 20 / Fs/2;  % ģ��Ƶ��20 תΪ ����Ƶ��
order = 30;

h = fir1(order, cut_off);

freqz(h) % plot �˲�����Ӧ��Ƶ��ͼ
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
plot(t, con(1+order/2: end-order/2)  ); grid on; % t �� con length��ͬ���õ���conӦ��ȥ��ǰ���һС���֣�ʹ�ú�ԭ����ͬ����
title('conv(y,h )');



subplot(324)
plot(t, y); grid on;
title('original y-t')

subplot(325)
plot(xfft, abs(fy/ max(fy)  )); grid on;
title('frequency domain')
xlabel('Hz')
ylabel('amp')




