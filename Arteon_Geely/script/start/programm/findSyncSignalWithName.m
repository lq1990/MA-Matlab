function [t_vec, data_vec] = findSyncSignalWithName(data_def_str)

id_str = strfind(data_def_str, '_t');
if isempty(id_str)
    data_name = evalin('base', ['who([''*', data_def_str, '*'']);']); 
else
    data_slice_str = data_def_str(1:id_str+1);
    data_name = evalin('base', ['who([''*', data_slice_str, '*'']);']); 
end

if isempty(data_name)
    t_vec = [];
    data_vec = [];
    disp([data_def_str, '  -   No data set found!']);
    return;
end

data_str = data_name{1};
id_str = strfind(data_str, '_t');
t_str = data_str(id_str+1:end);
t_vec = evalin('base', ['sync_', t_str]);
data_vec = evalin('base', data_str);

