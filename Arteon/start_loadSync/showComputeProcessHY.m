function showComputeProcessHY( matData, Wxh, Whh, Why, bh, by )
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

