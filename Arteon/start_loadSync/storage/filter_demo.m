clear;
close all;


%%
Fs = 200; % 采样频率
Ts = 1/Fs;
t = 0: Ts: 1-Ts;

f1 = 5;
f2 = 20;
f3 = 50;

y = 10*sin(2*pi*f1*t) + 5*sin(2*pi*f2*t) + 2*sin(2*pi*f3*t);

figure;
subplot(231)
plot(t,y); grid on;
title('y-t, original');

%% fft
nfft = length(y);
nfft2 = 2.^nextpow2(nfft);

fy = fft(y, nfft2);
fy = fy(1: nfft2/2);
xfft = Fs.*(0: nfft2/2-1) / nfft2;

subplot(232)
plot(xfft, abs(fy/max(fy))); grid on;
title('frequency domain, original');

%% filter
cut_off = 30 / Fs/2;
order = 4;
h = fir1(order, cut_off);
fh = fft(h, nfft2);
fh = fh(1: nfft2/2);
subplot(236)
plot(xfft, abs(fh/max(fh))); grid on;
title(['filter, order: ', num2str(order), ', cut off:', num2str(cut_off*Fs*2)]);


% freqz(h); % 滤波器的 幅频特性
%%
con = conv(y,h);
y_after = con(1+order/2 : end-order/2);
subplot(234)
plot(t, y_after); grid on;
title('y-t, after filtering');

%%
fy_after = fft(y_after, nfft2);
fy_after = fy_after(1: nfft2/2);
subplot(235)
plot(xfft, abs(fy_after / max(fy_after))); grid on;
title('frequency domain, after filtering');

