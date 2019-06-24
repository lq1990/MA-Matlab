classdef NeuronPattern
    %NEURONPATTERN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function plotNeuronPatternRawSignals( listStructTrain, neuronPatternSArr, signalTable, range_neurons, range_id, subplotRows, subplotCols )
                % plot the part of scenarios that activate a neuron
                % this part of scenario is called pattern.
                % labels depends on  recombination of different patterns 
                % many figures and subplot to show raw signals.
                amp = 5;
                [ score_min, score_max ] = MyPlot.findScoreMinMaxOfListStruct(listStructTrain, range_id);

            for i = 1 : length(neuronPatternSArr)
                % loop over every neuron
                if ~ismember(i, range_neurons)
                    continue
                end

                % ���ѭ��ȡ��ÿ��neuron��һ��neuron ��Ӧ���е�signals���ɶ��figure��subplotչʾ

                numSignals = 17;
                numFig = ceil(numSignals / (subplotRows * subplotCols)); % num of fig needed

                % generate figureid_list, it saves figure id
                figureid_list = [];
                for f = 1:numFig
                    figureid_list = [figureid_list, i + (f-1)*100]; %  i��neuron index

                    figure(figureid_list(f));
                    set(gcf, 'position', [500+(-f+1)*60, -(150+(f-1)*30), 1400, 900]);
                end

                cur_neuron = neuronPatternSArr(i);

                legend_cell = {};
                for j = 1 : length(listStructTrain)
                    if ~ismember(j, range_id)
                        continue
                    end

                    % �ڲ�ѭ������ÿ�������������listStruct�õ� id
                    item_id = listStructTrain(j).id; fprintf('item_id: %d\n', item_id);
                    item_id_str = ['id', num2str(item_id)];
                    item_id_str = strrep(item_id_str, '.', '_'); % replace
                    item_details = listStructTrain(j).details;
                    item_score = listStructTrain(j).score;

                    cur_neuron_id = cur_neuron.(item_id_str); % ��ǰneuron��Ӧ��һ������Ҫ������ʾ��index

                    % �Ƿ���ʾ��Щ û��pattern�ĳ�����ע��ʱ��ʾ
            %         if isempty(cur_neuron_id)
            %             continue
            %         end

                    % plot each column of matData to know the raw signals better
                    for i_signal = 1 : height(signalTable)
                        % loop over each signal
                        figureID = figureid_list( ceil(i_signal/(subplotRows * subplotCols)) );
                        subplotID = str2num( [num2str(subplotRows), num2str(subplotCols), '0'] ) + mod(i_signal - 1, (subplotRows*subplotCols))+1;
                        item_matData = listStructTrain(j).matData(:, i_signal);
                        signalName = signalTable.signalName(i_signal);
                        if i_signal==1
                            % legend_cell �����for�ڲ� ֻ����һ�Ρ�������forӰ�졣
                            ifShowLegend = 1;
                            legend_cell = NeuronPattern.plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );
                        else
                            ifShowLegend = 0;
                            legend_cell = NeuronPattern.plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend );
                        end

                    end

                end

                  if ~isempty(legend_cell)
                        legend(legend_cell);
                  end

            end

        end

        function out_legend_cell = plotOneColOfmatData( figureID, subplotID,  item_matData, item_score, score_min, score_max, amp, legend_cell, item_details, cur_neuron_id,  i, signalName, ifShowLegend )
            figure(figureID);
            subplot(subplotID);

            plot(item_matData,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
            grid on; hold on;
            if ifShowLegend==1 % ֻ��Ҫshow legend���Ǹ�figure���б�Ҫ�洢legend_cell
                legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
            end
            % �ٸ���ʹneuron����Ĳ���
            if ~isempty(cur_neuron_id)
                plot(cur_neuron_id, item_matData(cur_neuron_id), 'k*', 'LineWidth', 2);

                if ifShowLegend==1
                    legend_cell = [legend_cell, 'pattern'];
                end
            end
            title(['neuron ', num2str(i), ', ', signalName]);

            out_legend_cell = legend_cell;
        end

        function plotNeuronPatternPC12( listStructTrain, neuronPatternSArr, range_neurons, range_id )
                % plot the part of scenarios that activate a neuron
                % this part of scenario is called pattern.
                % labels depends on  recombination of different patterns 
                amp = 5;
                [ score_min, score_max ] = MyPlot.findScoreMinMaxOfListStruct(listStructTrain, range_id);

            for i = 1 : length(neuronPatternSArr)
                if ~ismember(i, range_neurons)
                    continue
                end

                % ���ѭ��ȡ��ÿ��neuron��һ��neuronһ��figure
                figure;
                set(gcf, 'position', [500, -100, 1000, 800]);
                cur_neuron = neuronPatternSArr(i);

                legend_cell = {};
                for j = 1 : length(listStructTrain)
                    if ~ismember(j, range_id)
                        continue
                    end

                    % �ڲ�ѭ������ÿ�������������listStruct�õ� id
                    item_id = listStructTrain(j).id;
                    item_id_str = ['id', num2str(item_id)];
                    item_id_str = strrep(item_id_str, '.', '_'); % replace
                    item_details = listStructTrain(j).details;
                    item_score = listStructTrain(j).score;
                    item_matDataPC1 = listStructTrain(j).matDataPcAll(:, 1); % ```ע��```���˴���PC1�ǰ��� mean_all std_all ����trainDataset��������train/test ͬ�ֲ�ʱ��û������
                    item_matDataPC2 = listStructTrain(j).matDataPcAll(:, 2); 

                    % plot each column of matData to know the raw signals better

                    cur_neuron_id = cur_neuron.(item_id_str); % ��ǰneuron��Ӧ��һ������Ҫ������ʾ��index

                    % �Ƿ���ʾ��Щ û��pattern�ĳ�����ע��ʱ��ʾ
            %         if isempty(cur_neuron_id)
            %             continue
            %         end

                    subplot(121)
                    % �Ȱ�matDataPC1 plot
                    plot(item_matDataPC1,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
                    grid on; hold on;
                    legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
                    % �ٸ���ʹneuron����Ĳ���
                    if ~isempty(cur_neuron_id)
                        plot(cur_neuron_id, item_matDataPC1(cur_neuron_id), 'ko', 'LineWidth', 1);
                        legend_cell = [legend_cell, 'pattern'];
                    end
                    title(['neuron ', num2str(i), ', PC1']);
            %         if ~isempty(legend_cell)
            %             legend(legend_cell);
            %         end

                    subplot(122)
                    % �Ȱ�matDataPC2 plot
                    plot(item_matDataPC2,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
                    grid on; hold on;
            %         legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
                    % �ٸ���ʹneuron����Ĳ���
                    if ~isempty(cur_neuron_id)
                        plot(cur_neuron_id, item_matDataPC2(cur_neuron_id), 'ko', 'LineWidth', 1);
            %         legend_cell = [legend_cell, 'pattern'];
                    end
                    title(['neuron ', num2str(i), ', PC2']);
                    if ~isempty(legend_cell)
                        legend(legend_cell);
                    end

                end

            end

        end

        function [out_positive, out_negative ] = neuronActTimeInSce1hidden( listStructTrain, Wxh, Whh, bh, margin)
            % ��¼��ÿ��neuron��������pattern���
            % ��struct�洢��ÿ��neuron�ڲ�ͬ��������valueֵ >=marginʱ����¼ʱ��
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
                                    mystruct_negative.(['neuron', num2str(i)]).(['id', num2str(id)]) = [ mystruct_negative.(['neuron', num2str(i)]).(['id', num2str(id)]), t ];
                                else
                                    mystruct_negative.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]) = [mystruct_negative.(['neuron', num2str(i)]).(['id', id_split_str{1}, '_',  id_split_str{2}]), t];
                                end
                            end
                       end

                   end

               end

           end

           fprintf('--- over --- \n');
           out_positive = mystruct_positive;
           out_negative = mystruct_negative;
        % һ����Ԫ����Ӧ�����������¼ÿ��������ʹ�������Ԫ����margin(eg. 90%)���ϵ� ʱ�̡�����Щʱ������������һ��һ�εģ�

        end

        function [out_positive, out_negative ] = neuronActTimeInSce2hidden(listStructTrain, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin)
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


        
    end
    
end

