clc;
close all;

addpath(genpath(pwd));

%% 先运行 dataStruct.m，从txt源文件 -> table , Arr

%% plot

mp = MyPlot(dataSArr, kpTable);
mp.showAllKp();