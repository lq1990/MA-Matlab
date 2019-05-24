% figure;
% plot([1,2],[3,4]); grid on;
% xlim([0 inf]);

clc;

%%  ‘—È (data-mean)/std

x = 1:0.1:10;
y = x + rand(1, length(x));

figure;
plot(x, y, '.'); grid on; hold on;

xNorm = (x-mean(x))/std(x);
yNorm = (y-mean(y))/std(y);
plot(xNorm, yNorm, '.');

%%
% for item = dataSArr
%     item.AccePedal
% end


% std1_cell = scenarioTable.dir(1); std1=std1_cell{1,1};
% std2_cell = scenarioTable.dir(2); std2=std2_cell{1,1};
% std4_cell = scenarioTable.dir(4); std4=std4_cell{1,1};
% strcmp(std1, std2)
% strcmp(std1, std4)
% 
% total = 100000;
% interval = 10;
% 
% t10 = clock;
% for i = 1:total
%     if mod(i, interval)    == 1
%         disp(i)
%     end
% end
% t11 = clock;
% 
% disp('------------------------');
% t20= clock;
% for i = 1: interval: total
%     disp(i)
% end
% t21 = clock;
% 
% fprintf('time1: %d\n', etime(t11, t10));
% fprintf('time2: %d\n', etime(t21, t20));