clear; clc;
ds = load('D:\MA\Daten\Messdaten\Messdaten_Arteon\Testdaten_09.04.2018_dry\Syncdaten\16-17-18_sync.mat');
t_begin = 69.54;
t_end = 72.44;

load('signalTable.mat');

num = 1;
factor = 1/10;

signal_name_table = signalTable(num, 'signalSyncName'); 
signal_name_cell = signal_name_table{1,1};
signal_name = signal_name_cell{1,1};

signal_time_table = signalTable(num, 'signalTimeName'); 
signal_time_cell = signal_time_table{1,1};
signal_time = signal_time_cell{1,1};

ms = MySignal(ds, signal_name, signal_time);
[idx_t_begin, idx_t_end, tData ,texData] = ms.findIdxTT( t_begin, t_end, factor);
