clear; clc; close all;

%% load
load('.\DataFinalSave\myArteonArr.mat');

%%  plot
% addpath kpClasses % addpath ��·��Ŀ¼��ӵ�����·����ȥ��ָ����ǰ��MATLAB·��
% addpath myClasses
addpath(genpath(pwd));

% MyPlot(myArteonArr, EngineSpeed);
% MyPlot(myArteonArr, VehicleSpeed);
% MyPlot(myArteonArr, Ax);
% MyPlot(myArteonArr, Ay);
% MyPlot(myArteonArr, AccPedal);
% MyPlot(myArteonArr, ThrottlePos);
% MyPlot(myArteonArr, KickDown);
% MyPlot(myArteonArr, EngineTorque);
% MyPlot(myArteonArr, TransmissionInputSpeed);
% MyPlot(myArteonArr, TargetGear);
% MyPlot(myArteonArr, ShiftProcess);
MyPlot(myArteonArr, BrakePressureRaw);
