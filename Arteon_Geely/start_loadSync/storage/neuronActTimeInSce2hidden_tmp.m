function [out_positive, out_negative ] = neuronActTimeInSce2hidden_tmp(listStructTrain, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin)
    % 记录，每个neuron将被何种pattern激活。这个pattern会在不同的场景中出现。
    % 有两个隐层，分别记录
    % 用struct存储，每个neuron在不同场景，当value值 >=margin时，记录时间
    n_neurons1 = size(Wh1h1, 1);
    n_neurons2 = size(Wh2h2, 1);
    
    mystruct_positive = struct;
    mystruct_negative = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(jj).id;
       
       % 考虑到 id有小数的情况, 将 . 用 _ 替代
       id_str = strrep(num2str(id), '.', '_');
       
       for ii = 1 : n_neurons1
           mystruct_positive.(['neuron10', num2str(ii)]).(['id', id_str]) = [];
           mystruct_negative.(['neuron10', num2str(ii)]).(['id', id_str]) = [];
       end
       
       for ii = 1 : n_neurons2
           mystruct_positive.(['neuron20', num2str(ii)]).(['id', id_str]) = [];
           mystruct_negative.(['neuron20', num2str(ii)]).(['id', id_str]) = [];
       end
           
     end
    
   for j = 1 : length(listStructTrain)
       % 遍历每个场景
       id = listStructTrain(j).id; 
       id_str = strrep(num2str(id), '.', '_'); % replace . with _
       matData = listStructTrain(j).matDataZScore; % train 的是zscore，所以此处也用
       fprintf('idx: %d, id: %d\n', j, id);

       H1_ = zeros(size(Wh1h1, 1), 1);
       H2_ = zeros(size(Wh2h2, 1), 1);
       
       for t = 1 : length(matData)
           % 遍历matData每行。t时刻的 H(i)若很大的话，t 将被记录下来
           % 前传，找到 最大(>=margin) 激活当前神经元的时刻
           curRow = matData(t, :)';
           H1raw = Wxh1 * curRow + Wh1h1 * H1_ + bh1;
           H1= tanh(H1raw); % (50,1)
           H1_ = H1; % update H_
           
           H2raw = Wh1h2 * H1 + Wh2h2 * H2_ + bh2;
           H2 = tanh(H2raw);
           H2_ = H2;

           for i = 1 :  n_neurons1
               % 遍历每个 hidden1 neuron
               % 取到当前neuron对应的行的值
               neuronRowVal = H1(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t 保存
                    if neuronRowVal > 0
                        % positive activate at the moment in the scenario of id
                        mystruct_positive.(['neuron10', num2str(i)]).(['id', id_str]) = [ mystruct_positive.(['neuron10', num2str(i)]).(['id', id_str]), t ];
                    else
                        % negative activate
                        mystruct_negative.(['neuron10', num2str(i)]).(['id', id_str]) = [ mystruct_negative.(['neuron10', num2str(i)]).(['id', id_str]), t ];
                    end
               end

           end
           
           for i = 1 :  n_neurons2
               % 遍历每个 hidden2 neuron
               % 取到当前neuron对应的行的值
               neuronRowVal = H2(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t 保存
                    if neuronRowVal > 0
                        % positive activate
                        mystruct_positive.(['neuron20', num2str(i)]).(['id', id_str]) = [ mystruct_positive.(['neuron20', num2str(i)]).(['id', id_str]), t ];
                    else
                        % negative activate
                        mystruct_negative.(['neuron20', num2str(i)]).(['id', id_str]) = [ mystruct_negative.(['neuron20', num2str(i)]).(['id', id_str]), t ];
                    end
               end

           end

       end

   end
       
   fprintf('--- over --- \n');
   out_positive = mystruct_positive;
   out_negative = mystruct_negative;

end

% 一个神经元：对应多个场景，记录每个场景中使得这个神经元激活margin(eg. 90%)以上的 时刻。（这些时刻往往是连续一段一段的）
