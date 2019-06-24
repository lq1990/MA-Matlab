function [out_positive, out_negative ] = neuronActTimeInSce2hidden_tmp(listStructTrain, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin)
    % ��¼��ÿ��neuron��������pattern������pattern���ڲ�ͬ�ĳ����г��֡�
    % ���������㣬�ֱ��¼
    % ��struct�洢��ÿ��neuron�ڲ�ͬ��������valueֵ >=marginʱ����¼ʱ��
    n_neurons1 = size(Wh1h1, 1);
    n_neurons2 = size(Wh2h2, 1);
    
    mystruct_positive = struct;
    mystruct_negative = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % ����ÿ������
       id = listStructTrain(jj).id;
       
       % ���ǵ� id��С�������, �� . �� _ ���
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
       % ����ÿ������
       id = listStructTrain(j).id; 
       id_str = strrep(num2str(id), '.', '_'); % replace . with _
       matData = listStructTrain(j).matDataZScore; % train ����zscore�����Դ˴�Ҳ��
       fprintf('idx: %d, id: %d\n', j, id);

       H1_ = zeros(size(Wh1h1, 1), 1);
       H2_ = zeros(size(Wh2h2, 1), 1);
       
       for t = 1 : length(matData)
           % ����matDataÿ�С�tʱ�̵� H(i)���ܴ�Ļ���t ������¼����
           % ǰ�����ҵ� ���(>=margin) ���ǰ��Ԫ��ʱ��
           curRow = matData(t, :)';
           H1raw = Wxh1 * curRow + Wh1h1 * H1_ + bh1;
           H1= tanh(H1raw); % (50,1)
           H1_ = H1; % update H_
           
           H2raw = Wh1h2 * H1 + Wh2h2 * H2_ + bh2;
           H2 = tanh(H2raw);
           H2_ = H2;

           for i = 1 :  n_neurons1
               % ����ÿ�� hidden1 neuron
               % ȡ����ǰneuron��Ӧ���е�ֵ
               neuronRowVal = H1(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t ����
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
               % ����ÿ�� hidden2 neuron
               % ȡ����ǰneuron��Ӧ���е�ֵ
               neuronRowVal = H2(i);
               if abs(neuronRowVal) >= margin % +/-
                   % t ����
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

% һ����Ԫ����Ӧ�����������¼ÿ��������ʹ�������Ԫ����margin(eg. 90%)���ϵ� ʱ�̡�����Щʱ������������һ��һ�εģ�
