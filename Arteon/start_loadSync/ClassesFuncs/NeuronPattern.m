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

                % 外层循环取得每个neuron，一个neuron 对应所有的signals，由多个figure的subplot展示

                numSignals = 17;
                numFig = ceil(numSignals / (subplotRows * subplotCols)); % num of fig needed

                % generate figureid_list, it saves figure id
                figureid_list = [];
                for f = 1:numFig
                    figureid_list = [figureid_list, i + (f-1)*100]; %  i：neuron index

                    figure(figureid_list(f));
                    set(gcf, 'position', [500+(-f+1)*60, -(150+(f-1)*30), 1400, 900]);
                end

                cur_neuron = neuronPatternSArr(i);

                legend_cell = {};
                for j = 1 : length(listStructTrain)
                    if ~ismember(j, range_id)
                        continue
                    end

                    % 内层循环遍历每个场景，需借助listStruct拿到 id
                    item_id = listStructTrain(j).id; fprintf('item_id: %d\n', item_id);
                    item_id_str = ['id', num2str(item_id)];
                    item_id_str = strrep(item_id_str, '.', '_'); % replace
                    item_details = listStructTrain(j).details;
                    item_score = listStructTrain(j).score;

                    cur_neuron_id = cur_neuron.(item_id_str); % 当前neuron对应的一个场景要高亮显示的index

                    % 是否显示那些 没有pattern的场景，注释时显示
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
                            % legend_cell 在这个for内部 只更新一次。避免受for影响。
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
            if ifShowLegend==1 % 只有要show legend的那个figure才有必要存储legend_cell
                legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
            end
            % 再高亮使neuron激活的部分
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

                % 外层循环取得每个neuron，一个neuron一个figure
                figure;
                set(gcf, 'position', [500, -100, 1000, 800]);
                cur_neuron = neuronPatternSArr(i);

                legend_cell = {};
                for j = 1 : length(listStructTrain)
                    if ~ismember(j, range_id)
                        continue
                    end

                    % 内层循环遍历每个场景，需借助listStruct拿到 id
                    item_id = listStructTrain(j).id;
                    item_id_str = ['id', num2str(item_id)];
                    item_id_str = strrep(item_id_str, '.', '_'); % replace
                    item_details = listStructTrain(j).details;
                    item_score = listStructTrain(j).score;
                    item_matDataPC1 = listStructTrain(j).matDataPcAll(:, 1); % ```注意```：此处的PC1是按照 mean_all std_all 而非trainDataset，不过当train/test 同分布时，没有问题
                    item_matDataPC2 = listStructTrain(j).matDataPcAll(:, 2); 

                    % plot each column of matData to know the raw signals better

                    cur_neuron_id = cur_neuron.(item_id_str); % 当前neuron对应的一个场景要高亮显示的index

                    % 是否显示那些 没有pattern的场景，注释时显示
            %         if isempty(cur_neuron_id)
            %             continue
            %         end

                    subplot(121)
                    % 先把matDataPC1 plot
                    plot(item_matDataPC1,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
                    grid on; hold on;
                    legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
                    % 再高亮使neuron激活的部分
                    if ~isempty(cur_neuron_id)
                        plot(cur_neuron_id, item_matDataPC1(cur_neuron_id), 'ko', 'LineWidth', 1);
                        legend_cell = [legend_cell, 'pattern'];
                    end
                    title(['neuron ', num2str(i), ', PC1']);
            %         if ~isempty(legend_cell)
            %             legend(legend_cell);
            %         end

                    subplot(122)
                    % 先把matDataPC2 plot
                    plot(item_matDataPC2,'-', 'LineWidth', (item_score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
                    grid on; hold on;
            %         legend_cell = [legend_cell, ['score: ', num2str(item_score), ', ', item_details]];
                    % 再高亮使neuron激活的部分
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
            % 记录，每个neuron将被何种pattern激活。
            % 用struct存储，每个neuron在不同场景，当value值 >=margin时，记录时间
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
        % 一个神经元：对应多个场景，记录每个场景中使得这个神经元激活margin(eg. 90%)以上的 时刻。（这些时刻往往是连续一段一段的）

        end

        function [out_positive, out_negative ] = neuronActTimeInSce2hidden(listStructTrain, Wxh1, Wh1h1, Wh1h2, Wh2h2, bh1,  bh2, margin)
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


        
    end
    
end

