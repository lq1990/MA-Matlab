clc;
close all;

addpath(genpath(pwd));

%% ������ dataStruct.m����txtԴ�ļ� -> table , Arr

%% plot

mp = MyPlot(dataSArr, kpTable);
mp.showAllKp();