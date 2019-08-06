function showComputeProcessHY2Hidden_tmp( matData, Wxh1, Wh1h1, Wh1h2, Wh2h2, Wh2y, bh1, bh2, by )
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

