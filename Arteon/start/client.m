clear; clc; close all;

%% load
load('.\savedFinalData\myArteonArr.mat')

%%  plot
addpath kpClasses % addpath 将路径目录添加到搜索路径中去，指定当前的MATLAB路径
addpath myClasses

MyPlot(myArteonArr, EngineSpeed);
MyPlot(myArteonArr, VehicleSpeed);
MyPlot(myArteonArr, Ax);
MyPlot(myArteonArr, Ay);
MyPlot(myArteonArr, AccPedal);
MyPlot(myArteonArr, ThrottlePos);
MyPlot(myArteonArr, KickDown);
MyPlot(myArteonArr, EngineTorque);
