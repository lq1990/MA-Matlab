function showParams_tmp( param_str, ifaxisequal )
figure;

file = [param_str, '.txt'];

if strcmp(param_str, 'Wxh')
    data = importfile_Wxh(file);
    
    signalT = importfile_signal('signalsOfSync.txt');
    
    offset = 10;
    showXtickLabel(data, signalT, offset);

    ylabel('neurons in hidden layer');
    
elseif strcmp(param_str, 'Whh')
    data = importfile_Whh(file);
    
elseif strcmp(param_str, 'Why')
    data = importfile_Why(file);
    
elseif strcmp(param_str, 'bh')
    data = importfile_bh(file);

elseif strcmp(param_str, 'by')
    data = importfile_by(file);
    
end

showMatrix(param_str,data, ifaxisequal, '');


end

