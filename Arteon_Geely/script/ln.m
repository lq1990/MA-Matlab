% softmax fn = -ln(x)


clear; clc; close all;

figure;
x = 0:0.01: 1;
y = -log(x);

plot(x,y, 'k', 'LineWidth', 1); grid on;
xlabel('probability');
ylabel('loss');
title('loss function');

