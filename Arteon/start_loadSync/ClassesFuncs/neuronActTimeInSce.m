function [out_positive, out_negative ] = neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin)

    % ��¼��ÿ��neuron��������pattern���
    % ��struct�洢��ÿ��neuron�ڲ�ͬ��������valueֵ >=0.9ʱ����¼ʱ��
    n_neurons = size(Whh, 1);
    mystruct_positive = struct;
    mystruct_negative = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % ����ÿ������
       id = listStructTrain(jj).id;
       
       % ���ǵ� id��С�����������Ҫ��� �� . �� _ ���
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
       % ����ÿ������
       id = listStructTrain(j).id; 
       id_split_str = strsplit(num2str(id), '.'); % cell
       matData = listStructTrain(j).matDataZScore;
       fprintf('idx: %d, id: %d\n', j, id);

       H_ = zeros(size(Whh, 1), 1);
       for t = 1 : length(matData)
           % ����matDataÿ�С�tʱ�̵� H(i)���ܴ�Ļ���t ������¼����
           % ǰ�����ҵ� ���(>=0.9) ���ǰ��Ԫ��ʱ��
           curRow = matData(t, :)';
           Hraw = Wxh * curRow + Whh * H_ + bh;
           H = tanh(Hraw); % (50,1)
           H_ = H; % update H_

           for i = 1 :  n_neurons
               % ����ÿ�� hidden neuron
               % ȡ����ǰneuron��Ӧ���е�ֵ
               
               neuronRowVal = H(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t ����
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

% һ����Ԫ����Ӧ�����������¼ÿ��������ʹ�������Ԫ����90%���ϵ� ʱ�̡�����Щʱ������������һ��һ�εģ�
