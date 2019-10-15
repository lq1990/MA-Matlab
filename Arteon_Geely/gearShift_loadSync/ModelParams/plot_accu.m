% 

clc; close all;

figure;
accu0 =importfile_accu_lam0('accuracy_each_epoch_lam0.txt');

x = 1:50;
plot(x, accu0(x), 'k', 'LineWidth', 1); grid on;
xlabel('epoch');
ylabel('accuracy');
title('Training accuracy without dropout or penalty');
set(gca, 'YTick',0.5:0.1:1);
set(gca, 'FontSize', 12);
set(gca,'fontweight','bold');



