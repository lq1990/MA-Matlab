function [ prob, idx ] = predictScore_tmp( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses )
    % use FP to predict score_classes of all scenarios of list_data
    
    for i = 1 : length(list_data) % loop over each scenarios of Geely
        id = list_data(i).id;
        score = list_data(i).score;
        score_class = score2class(score, maxScore, minScore, numClasses);
        matData = list_data(i).matData;

        H_ = zeros(length(Whh) ,1); % init H_
        for r = 1 : length(matData)
            % use FP and W b to predict scores
            curRow = matData(r, :)';

            Hraw = Wxh * curRow + Whh * H_ + bh;
            H = tanh(Hraw);
            H_ = H; % update H_

            if r == length(matData)
                YModel = Why * H + by;
                Prob = softmax(YModel);
                [prob, idx] = max(Prob);
                fprintf('id: %g, target class: %d, predicted class: %d, prob: %g\n', id, score_class, idx, prob);
            end
        end
    end
end

