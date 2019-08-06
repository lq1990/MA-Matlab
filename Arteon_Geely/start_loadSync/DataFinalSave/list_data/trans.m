% trans matDataZScore => matDataZScore_t
% so, matDataZScore.getRow(i) => matDataZScore_t.getCol(i)

clear;
clc;
close all;
%% listStructTrain
load listStructTrain

for idx_sce = 1:length(listStructTrain)
   matDataZScore = listStructTrain(idx_sce).matDataZScore;
   matDataZScore_t = matDataZScore';
    
   listStructTrain(idx_sce).matDataZScore_t = matDataZScore_t;
end

%% listStructCV
load listStructCV

for idx_sce = 1:length(listStructCV)
   matDataZScore = listStructCV(idx_sce).matDataZScore;
   matDataZScore_t = matDataZScore';
    
   listStructCV(idx_sce).matDataZScore_t = matDataZScore_t;
end

%% save
save '.\DataFinalSave\listStructTrain' listStructTrain
save '.\DataFinalSave\listStructCV' listStructCV

%% listStructTest
% don't use test-dataset in C++
