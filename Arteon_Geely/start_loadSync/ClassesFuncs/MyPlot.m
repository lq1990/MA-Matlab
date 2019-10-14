classdef MyPlot
    % myArr中，每一列plot
    % 即：将每一个signal对应的所有场景包含得分 plot
    
    % static fn: showMatrix
    
    properties
        m_Arr;
        m_signalTable;
        m_range_id; % 要plot的场景，格式为 [ m : n]
        m_range_signal;
        m_amp;
    end
    
    methods
        function mp = MyPlot(myArr, signalTable, range_id, range_signal, amp)
            disp('MyPlot...');
            mp.m_Arr = myArr;
            mp.m_signalTable = signalTable;
            mp.m_range_id = range_id;
            mp.m_range_signal = range_signal;
            mp.m_amp = amp;
        end
        
        function show(mp)
            [maxV, minV] = mp.findMM(); % dataSArr 所有score 中 max，min。留着为画图时线宽用。
%             amp = 10; % 画图时线粗方法倍数
            amp = mp.m_amp;
            
%             for idx_signal = 1 : height(mp.m_signalTable) 
            for idx_signal = mp.m_range_signal
                figure; % 一个signal一个figure
                set(gcf, 'position', [50, -100, 1000, 800]);
                signalname_cell = mp.m_signalTable.signalName(idx_signal); 
                signalname = signalname_cell{1,1};
                signalunit_cell = mp.m_signalTable.unit(idx_signal);
                signalunit = signalunit_cell{1,1};

                legend_cell = {};
                i = 1;
                for item = mp.m_Arr % 一个signal对应所有场景的数据，plot
                    if ~ismember(i, mp.m_range_id)
                         i = i+1;
                        continue
                    end
                    data = item.(signalname);
                    details = item.details;
                    score = item.score;
                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(data, 'LineWidth', (score-minV)/(maxV-minV)*amp+1); grid on; hold on;
                    
                    i = i+1;
                end

                title(signalname);
                xlabel('time, [s*10]');
                xlim([1 inf]);
                ylabel(signalunit);
                legend(legend_cell);
            end
        end
        
        function [maxV, minV] = findMM(mp)
            % 找到被选择的 所有场景的得分最大、最小值。
            score_list = [];
            i = 1;
            for item = mp.m_Arr
                if ~ismember(i, mp.m_range_id) % 如果没被选择
                     i = i+1;
                    continue
                end
                score_list = [score_list, item.score];
                i = i+1;
            end
            maxV = max(score_list);
            minV = min(score_list);
        end

    end
    
    methods(Static)
        
        function plotSignalsOfListStruct(listStruct, signalTable, range_id, range_signal, plotZScore, lineTyp, amp)
            % plot matData or matDataZScore of listStruct, 
            % each col representes a signal
            [ score_min, score_max ] = MyPlot.findScoreMinMaxOfListStruct(listStruct, range_id);
            
            for i = 1 : height(signalTable)
                if ~ismember(i, range_signal)
                    continue
                end
                
                figure; % 一个signal一个figure，对应listStruct.matData的一列
                legend_cell = {};
                set(gcf, 'position', [50, -100, 1000, 800]);
                signalname_cell = signalTable.signalName(i); signalname = signalname_cell{1,1};
                for j = 1 : length(listStruct)
                     if ~ismember(j, range_id)
                        continue
                    end
                    
                    itemSce = listStruct(j);
                    id = itemSce.id;
                    score = itemSce.score;
                    details = itemSce.details;
                    
                    if plotZScore == 0
                        matData = itemSce.matData(: , i); % 一个signal对应一列
                    else
                        matData = itemSce.matDataZScore(: , i);
                    end
                    
                    idstr = num2str(id);
                    if idstr(1) == '1' % Arteon
                        linetyp = lineTyp{1};
                    else % Geely
                        linetyp = lineTyp{2};
                    end
                    
                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(matData, linetyp, 'LineWidth', (score-score_min)/(score_max-score_min+1e-8) * amp+0.5); 
                    grid on; hold on;
                    
                end
                title(signalname);
                legend(legend_cell);
                
            end
            
        end
        
        function plotMatDataPcEachSce( listStructAll, range_id, pcs, amp, lineType)
            score_list = [];
            for i = 1 : length(listStructAll)
                if ~ismember(i, range_id)
                    continue
                end

                item = listStructAll(i);
                score_list = [score_list; item.score];
            end
            score_max = max(score_list);
            score_min = min(score_list);

            for pc = pcs
                % 一个pc一个图
                figure;
                set(gcf, 'position', [50, -100, 1000, 800]);
                legend_cell = {};
                for i = 1:length(listStructAll)
                    if ~ismember(i, range_id)
                        continue
                    end

                    item = listStructAll(i);
                    id = item.id;
                    score = item.score;
                    details = item.details;
                    matDataPc = item.matDataPcAll(:, pc);

                    idstr = num2str(id);
                    if idstr(1) == '1' % Arteon
                        linetyp = lineType{1};
                    else % Geely
                        linetyp = lineType{2};
                    end

                    legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                    plot(matDataPc, linetyp, 'LineWidth', (score - score_min)/(score_max-score_min + 1e-8)*amp +1 );
                    grid on; hold on;
                end

                title(['PC', num2str(pc)]);
                legend(legend_cell);
                xlabel('time. sampling freq: 100hz'); 
             end
        end

        function plot3DMatDataPcTime( listStructAll, range_id, pcs, amp )
            score_list = [];
            for i = 1 : length(listStructAll)
                if ~ismember(i, range_id)
                    continue
                end

                item = listStructAll(i);
                score_list = [score_list; item.score];
            end
            score_max = max(score_list);
            score_min = min(score_list);

            for i = 1 : 2 : length(pcs)
                pc = [i, i+1];
               MyPlot.plot3DFor2(listStructAll, range_id, pc, score_max, score_min, amp );
            end
        end
        
        function plot3DFor2(listStructAll, range_id, pcs, score_max, score_min, amp )
            % pcs: [pc1, pc2] or [pc3, pc4] or ...
            figure;
            legend_cell = {};
            for i = 1 : length(listStructAll)
                 if ~ismember(i, range_id)
                    continue
                 end

                item = listStructAll(i);
                id = item.id;
                score = item.score;
                details = item.details;

                % line type
                idstr = num2str(id);
                if idstr(1) == '1' % Arteon
                    linetyp = '-';
                else % Geely
                    linetyp = '-.';
                end

                pc1 = item.matDataPcAll(:, pcs(1));
                pc2 = item.matDataPcAll(:, pcs(2));
                time = (1:length(pc1))';

                legend_cell = [legend_cell, ['score: ', num2str(score),', ' ,details]];
                plot3(time, pc1, pc2, linetyp, 'LineWidth', (score - score_min)/(score_max-score_min + 1e-8)*amp +0.5); 
                grid on; hold on;

            end

            xlabel('time');
            ylabel(['PC', num2str(pcs(1))]);
            zlabel(['PC', num2str(pcs(2))]);
            legend(legend_cell);
        end
        
        function [ score_min, score_max ] = findScoreMinMaxOfListStruct(listStruct, range_id)
             score_list = [];
            for i = 1 : length(listStruct)
                if ~ismember(i, range_id)
                    continue
                end

                item = listStruct(i);
                score_list = [score_list; item.score];
            end
            score_max = max(score_list);
            score_min = min(score_list);
        end
        
        function plotHist( listStruct, left, interval, right, title)
            len = length(listStruct);

            classes = (right-left)/interval; 

            edges = left : interval : right;
            xlimit = [left,right];
            titleStr = strcat(title, ', len: ', num2str(len), ', classes: ', num2str(classes));
            MyPlot.plotHistogram(listStruct, edges, xlimit, titleStr);

            set(gca,'XTick', left : interval : right);

        end
        
        function plotHistogram(listStruct, edges, xlimit, titleStr)
            score_list = [];
            for i = 1 : length(listStruct)
                item = listStruct(i);
                score_list = [score_list; item.score];
            end
            figure;
%             edges = [6:0.3:9.0];
            histogram(score_list, edges);
            grid on;
%             xlim([5,10]);
            xlim(xlimit);
            title(titleStr);
        end
        
        function showParams( param_str, ifaxisequal )
            figure;
            set(gcf, 'position', [50, -100, 1000, 800]);
            
            file = [param_str, '.txt'];
            if strcmp(param_str, 'Wxh')
                data = importfile_Wxh(file);
                
                signalTable = load('signalTable.mat');
                signalT = signalTable.signalTable;
                
                offset = 10;
                MyPlot.showXtickLabel(data, signalT, offset); % x tick label shows names of different signals
                ylabel('neurons in hidden layer');

            elseif strcmp(param_str, 'Whh')
                data = importfile_Whh(file);

            elseif strcmp(param_str, 'Why')
                data = importfile_Why(file);

            elseif strcmp(param_str, 'bh')
                data = importfile_bh(file);

            elseif strcmp(param_str, 'by')
                data = importfile_by(file);
            
            % two hidden layers
            elseif strcmp(param_str, 'Wxh1')
                data = importfile_Wxh1(file);
                
                signalTable = load('signalTable.mat');
                signalT = signalTable.signalTable;
                
                offset = 10;
                MyPlot.showXtickLabel(data, signalT, offset); % x tick label shows names of different signals
                ylabel('neurons in hidden layer');
                
            elseif strcmp(param_str, 'Wh1h1')
                data = importfile_Wh1h1(file);
                
            elseif strcmp(param_str, 'Wh1h2')
                data = importfile_Wh1h2(file);
                
            elseif strcmp(param_str, 'Wh2h2')
                data = importfile_Wh2h2(file);
                
            elseif strcmp(param_str, 'Wh2y')
                data = importfile_Wh2y(file);
                
            elseif strcmp(param_str, 'bh1')
                data = importfile_bh1(file); 
            
            elseif strcmp(param_str, 'bh2')
                data = importfile_bh2(file); 
                
            elseif strcmp(param_str, 'by')
                data = importfile_by(file); 
                
            % lstm 1hidden
            elseif strcmp(param_str, 'Wi1')
                data = importfile_Wi1(file); 
            elseif strcmp(param_str, 'Wo1')
                data = importfile_Wo1(file); 
            elseif strcmp(param_str, 'Whh1')
                data = importfile_Whh1(file); 
            elseif strcmp(param_str, 'Wc1')
                data = importfile_Wc1(file); 
            elseif strcmp(param_str, 'Wf1')
                data = importfile_Wf1(file); 
                
            elseif strcmp(param_str, 'bi1')
                data = importfile_bi1(file); 
            elseif strcmp(param_str, 'bo1')
                data = importfile_bo1(file); 
            elseif strcmp(param_str, 'bhh1')
                data = importfile_bhh1(file); 
            elseif strcmp(param_str, 'bc1')
                data = importfile_bc1(file); 
            elseif strcmp(param_str, 'bf1')
                data = importfile_bf1(file); 
            
            end

            MyPlot.showMatrix(param_str,data, ifaxisequal, '');
        end
        
        function showMatrix(param_str, data,  ifaxisequal, titleStr)
            if strcmp(param_str, 'cov')
                signalTable = load('signalTable.mat');
                signalT = signalTable.signalTable;
                offset = 1;
                MyPlot.showXtickLabel(data, signalT, offset);
            end
            if strcmp(param_str, 'eigenvector')
                signalTable = load('signalTable.mat');
                signalT = signalTable.signalTable;
                offset = 1;
                MyPlot.showYtickLabel(data, signalT, offset);
            end

            [n_rows, n_cols] = size(data);
            width_max = 1;
            height_max = 1;
            val_max = max(data(:));
            val_min = min(data(:));
            val_abs_max = max(abs(data(:)));

            for r = 1:n_rows
                for c = 1:n_cols
                    val = data(r, c);
                    val_scaling = val / (val_abs_max+ 1e-8);
                    val_scaling = abs(val_scaling);
                    % 有矩阵index得到坐标x,y
                    x = c;
                    y = r;

                    if val >= 0
                        facecolor = 'r';
                    else
                        facecolor = 'b';
                    end
            %         fprintf('row: %d, col: %d\n', r, c);
            %         fprintf('width_max: %d\n',width_max);
            %         fprintf('val_scaling: %d\n',val_scaling);
            %         fprintf('height_max: %d\n',height_max);

                    rectangle('Position', [x - width_max*val_scaling/2,... 
                                                    y - height_max*val_scaling/2, ...
                                                    width_max*val_scaling, ... 
                                                    height_max*val_scaling], ...
                                                'FaceColor', facecolor);

                end
            end

            title([titleStr, ' ', param_str, ' maxVal: ', num2str(val_max), ', minVal: ', num2str(val_min), ', red: +, blue: - ']);
            grid on;
            set(gca, 'YTick', 1:1:n_rows);
            axis ij
            if ifaxisequal == 1
                axis equal
            end
        end
        
        function showXtickLabel(data, signalT, offset)
            myxticklabel = {};
            for i = 1:height(signalT)
                signalName_cell = signalT.signalName(i);
                signalName = signalName_cell{1,1};
                myxticklabel = [myxticklabel, [num2str(i), ' ', signalName]];
            end

            set(gca, 'xticklabel', []);
            h = height(signalT);
            xpos = 1:h;
            ypos = ones(1, h)+ size(data, 1) + offset; % 设置显示text的 ypos
            text(xpos, ypos,...
                    myxticklabel, ...
                    'HorizontalAlignment', 'center', ...
                    'rotation', 70,...
                    'FontWeight', 'Bold'); % HorizontalAlignment 设置旋转轴 right left center
        
        end
        
        function showYtickLabel(data, signalT, offset)
            myyticklabel = {};
            for i = 1:height(signalT)
                signalName_cell = signalT.signalName(i);
                signalName = signalName_cell{1,1};
                myyticklabel = [myyticklabel, [num2str(i), ' ', signalName]];
            end

            set(gca, 'yticklabel', []);
            h = height(signalT);
            ypos = 1:h;
            xpos = ones(h, 1)+ size(data, 1) + offset; % 设置显示text的 ypos
            text(xpos, ypos,...
                    myyticklabel, ...
                    'HorizontalAlignment', 'center', ...
                    'rotation', 0,...
                    'FontWeight', 'Bold'); % HorizontalAlignment 设置旋转轴 right left center

            end
        
    end
end

