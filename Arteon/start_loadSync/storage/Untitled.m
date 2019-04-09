% figure;
% plot([1,2],[3,4]); grid on;
% xlim([0 inf]);

clc;
%%
% for item = dataSArr
%     item.AccePedal
% end


std1_cell = scenarioTable.dir(1); std1=std1_cell{1,1};
std2_cell = scenarioTable.dir(2); std2=std2_cell{1,1};
std4_cell = scenarioTable.dir(4); std4=std4_cell{1,1};
strcmp(std1, std2)
strcmp(std1, std4)
