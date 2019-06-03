function out = neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin)
    % 记录，每个neuron将被何种pattern激活。
    % 用struct存储，每个neuron在不同场景，当value值 >=0.9时，记录时间
    n_neurons = size(Whh, 1);
    mystruct = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(jj).id;
       
       for ii = 1 : n_neurons
           mystruct.(['neuron', num2str(ii)]).(['id', num2str(id)]) = [];
       end
           
     end
    
    
   for j = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(j).id;
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
               if abs(neuronRowVal) >= margin
                   % t 保存
%                    fprintf('t: %d\n', t);
%                     fprintf('t: %d, H(i): %d \n', t, abs(H(i)));
                    mystruct.(['neuron', num2str(i)]).(['id', num2str(id)]) = [ mystruct.(['neuron', num2str(i)]).(['id', num2str(id)]), t ];
               end

           end

       end

   end
       
   fprintf('--- over --- \n');
   out = mystruct;

end

% 一个神经元：对应多个场景，记录每个场景中使得这个神经元激活90%以上的 时刻。（这些时刻往往是连续一段一段的）
