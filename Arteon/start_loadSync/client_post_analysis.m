% features of Training/Test
%   TransmInpSpeed, ShiftPrecess

% label (score) distribute not identically

%% distribution of score of Arteon and Geely
scenarioTable_Arteon = load('scenarioTable');
scenario_Arteon = scenarioTable_Arteon.scenarioTable;
scores_Arteon = scenario_Arteon.score;
scores_Arteon_sort = sort(scores_Arteon);

scenarioTableGeely = load('scenarioTable_Geely');
scenario_Geely = scenarioTableGeely.scenarioTable_Geely;
scores_Geely = scenario_Geely.score;
scores_Geely_sort = sort(scores_Geely);

figure;
ylimMax = 6;
subplot(211);
hist(scores_Arteon); grid on;
title('Arteon hist');
xlim([5,10]);
ylim([0,ylimMax]);

subplot(212);
hist(scores_Geely); grid on;
title('Geely hist');
xlim([5,10]);
ylim([0,ylimMax]);