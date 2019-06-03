function out = neuronActTimeInSce( listStructTrain, Wxh, Whh, bh, margin)
    % ��¼��ÿ��neuron��������pattern���
    % ��struct�洢��ÿ��neuron�ڲ�ͬ��������valueֵ >=0.9ʱ����¼ʱ��
    n_neurons = size(Whh, 1);
    mystruct = struct;
    
    % init mystruct
     for jj = 1 : length(listStructTrain)
       % ����ÿ������
       id = listStructTrain(jj).id;
       
       for ii = 1 : n_neurons
           mystruct.(['neuron', num2str(ii)]).(['id', num2str(id)]) = [];
       end
           
     end
    
    
   for j = 1 : length(listStructTrain)
       % ����ÿ������
       id = listStructTrain(j).id;
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
               if abs(neuronRowVal) >= margin
                   % t ����
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

% һ����Ԫ����Ӧ�����������¼ÿ��������ʹ�������Ԫ����90%���ϵ� ʱ�̡�����Щʱ������������һ��һ�εģ�
