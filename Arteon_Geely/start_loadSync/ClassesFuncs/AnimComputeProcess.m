classdef AnimComputeProcess
    %ANIMCOMPUTEPROCESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function showComputeProcessHY1Hidden( matData, Wxh, Whh, Why, bh, by )
            % show computing process of RNN,
            %     especially computing of hidden and output neurons
            figure;
            H_ = zeros(size(Whh, 1), 1); % Hprev
            for r = 1 : length(matData)
                clf;
        %         subplot(231); % X_
        %         if r > 1
        %         MyPlot.showMatrix('X-', matData(r-1, :)', 0, num2str(r-1)); % col vector
        %         end

                subplot(2,3, [1,4]); % X
                curRow = matData(r, :)'; % X
                MyPlot.showMatrix('X', curRow, 0, num2str(r));

        %         subplot(232) % H_
        %         MyPlot.showMatrix('H-', H_, 0, num2str(r-1));

                Hraw = Wxh * curRow + Whh * H_ + bh;
                H = tanh(Hraw);

                fprintf('t: %d, H(2): %g \n', r, abs(H(2))); % 查看第二个neuron

                subplot(2, 3, [2, 5]) % H
                MyPlot.showMatrix('H', H, 0, num2str(r));

                H_ = H; % update H_
                if r == length(matData)
                    YModel = Why * H + by;
                    Prob = softmax(YModel); % only for column vector

                    % visulize Prob
                    subplot(236);
                    MyPlot.showMatrix('YModel Softmax', Prob, 1, '');

                end

                pause(0.1);
                drawnow
            end

        end

        function showComputeProcessHY2Hidden( matData, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by )
            % show computing process of RNN,
            %     especially computing of hidden and output neurons
            figure;
            H1_ = zeros(size(Wh1h1, 1), 1); % Hprev
            H2_ = zeros(size(Wh2h2, 1), 1);

            for r = 1 : length(matData)
                clf;

                curRow = matData(r, :)'; % X

                subplot(141); % X
                MyPlot.showMatrix('X', curRow, 0, num2str(r));

                H1raw = Wxh1 * curRow + Wh1h1 * H1_ + bh1;
                H1 = tanh(H1raw);
                H1_ = H1; % update H_
        %         fprintf('t: %d, H(2): %g \n', r, abs(H1(2))); % 查看第二个neuron

                subplot(142) % H1
                MyPlot.showMatrix('H1', H1, 0, num2str(r));

                H2raw = Wh1h2 * H1 + Wh2h2 * H2_ + bh2;
                H2 = tanh(H2raw);
                H2_ = H2;

                subplot(143) % H1
                MyPlot.showMatrix('H2', H2, 0, num2str(r));

                if r == length(matData)
                    YModel = Wh2y * H2 + by;
                    Prob = softmax(YModel); % only for column vector

                    % visualize Prob
                    subplot(144);
                    MyPlot.showMatrix('YModel Softmax', Prob, 1, '');

                end

                pause(0.1);
                drawnow
            end

        end



    end
    
end

