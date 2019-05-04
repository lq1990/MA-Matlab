% 为了 上采样做 准备
close all;
clc;
clear;

%% Linear Spline
t0 = clock;

t = 20:0.1:1000;
y = 2*sin(2*t)+sin(t);

figure;
plot(t,y, 'o'); grid on; hold on;

num = (length(t)-2)*2 + 2;
X = zeros(num, num);
Y = zeros(num,1);
for c = 1:(length(t)-1)
    X(c*2-1,c*2-1) = 1;
    X(c*2-1,c*2-1+1) = t(c);
    X(c*2-1+1, c*2-1) = 1;
    X(c*2-1+1, c*2-1+1) = t(c+1);
    
    Y(c*2-1,1) = y(c);
    Y(c*2-1+1,1) = y(c+1);
end
X = sparse(X);
W = X\Y;

disp(etime(clock, t0));
%%
% new x
t_new = min(t): 0.1 : max(t);
y_new = [];
for x_t = t_new
    one_part = (max(t)-min(t))/(length(t)-1); % 每一份的大小
    idx = floor( (x_t-min(t) )/ (one_part+1e-8) ) +1 ;
    b = W(idx*2-1, 1); % 对于 新的x 对应的参数
    a = W(idx*2-1+1,1);
    y_new_a = 1*b + x_t * a;
    y_new = [y_new, y_new_a];

end

plot(t_new, y_new); 


%% use myInterp
ds = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');
data = ds.sync_CAN2_OBD_01_OBD_Abs_Throttle_Pos_t7;
t = ds.sync_t7;

%%
% x = [2,3.5, 4,6.5, 7];
% data = sin(2*x) + sin(x)/2;


figure;
subplot(211)
plot(t, data, '.'); grid on;

% extend
factor = 10;
t_new = myInterp(t, factor);
data_new = myInterp(data, factor);

subplot(212)
plot(t_new, data_new, '.'); grid on;




