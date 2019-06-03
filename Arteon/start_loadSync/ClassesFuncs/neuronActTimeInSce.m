function [out_positive, out_negative ] = neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin)

    % 记录，每个neuron将被何种pattern激活。
    % 用struct存储，每个neuron在不同场景，当value值 >=0.9时，记录时间
    n_neurons = size(Whh, 1);
    mystruct_positive = struct;
    mystruct_negative = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(jj).id;
       
       % 考虑到 id有小数的情况，需要拆分 将 . 用 _ 替代
       id_split_str = strsplit(num2str(id), '.'); % cell
       
       for ii = 1 : n_neurons
           
           if length(id_split_str)==1
               mystruct_positive.(['neuron', num2str(ii)]).(['id', id_split_str{1} ]) = [];
               mystruct_negative.(['neuron', num2str(ii)]).(['id', id_split_str{1} ]) = [];
           else
               mystruct_positive.(['neuron', num2str(ii)]).(['id', id_split_str{1}, '_',  id_split_str{2}]) = [];
               mystruct_negative.(['neuron', num2str(ii)]).(['id', id_split_str{1}, '_',  id_split_str{2}]) = [];
           end
           
       end
           
     end
    
   for j = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(j).id; 
       id_split_str = strsplit(num2str(id), '.'); % cell
       matData = listStructTrain(j).matDataZScore;
       fprintf('idx: %d, id: %d\n', j, id);

       H_ = zeros(size(Whh, 1), 1);
       for t = 1 : length(matData)
           % 遍历matData每行。t时刻的 H(i)若很大的话，t 将被记录下来
           % 前传，找到 最大(>=0.9) 激活当前神经元的时刻
           curRow = matData(t, :)';
           Hraw = Wxh * curRow + Whh * H_ + bh;
           H = tanh(Hraw); % (50,1)
           H_ = H; % update H_

           for i = 1 :  n_neurons
               % 遍历每个 hidden neuron
               % 取到当前neuron对应的行的值
               
               neuronRowVal = H(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t 保存
                    if neuronRowVal > 0
                        % positive activate
                        if length(id_split_str)==1
                            mystruct_positive.(['neuron', num2str(i)]).(['id', num2str(id)]) = [ mystruct_positive.(['neuron', num2str(i)]).(['id', num2str(id)]), t ];
                        else
                            mystruct_positive.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]) = [mystruct_positive.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]), t];
                        end
                    else
                        % negative activate
                        if length(id_split_str)==1
                            mystruct_negative.(['neuron', num2str(i)]).(['id', num2str(id)]) = [ mystruct_positive.(['neuron', num2str(i)]).(['id', num2str(id)]), t ];
                        else
                            mystruct_negative.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]) = [mystruct_positive.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]), t];
                        end
                    end
               end

           end

       end

   end
       
   fprintf('--- over --- \n');
   out_positive = mystruct_positive;
   out_negative = mystruct_negative;

end

% 一个神经元：对应多个场景，记录每个场景中使得这个神经元激活90%以上的 时刻。（这些时刻往往是连续一段一段的）
