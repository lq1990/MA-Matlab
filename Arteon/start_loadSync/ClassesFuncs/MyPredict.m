classdef MyPredict
    % use Parameters to predict score of new scenarios
    
    properties
    end
    
    methods
    end
    
    methods(Static)
        function printAll( list_data, Wxh, Whh, Why, bh, by, maxScore, minScore, numClasses )
            fprintf('===========================================================\n');
            % use FP to predict score_classes of all scenarios of list_data
            for i = 1 : length(list_data) % loop over each scenarios of Geely
                id = list_data(i).id;
                score = list_data(i).score;
                target_class =MyPredict.score2class(score, maxScore, minScore, numClasses);
                matData = list_data(i).matData;

                [prob, pred_class]=MyPredict.predictOneScenario(matData, Wxh, Whh, Why, bh, by);
                pred_score = MyPredict.class2score(pred_class, maxScore, minScore, numClasses);
                
                if target_class == pred_class
                    true_false = 'true';
                else
                    true_false = '---false---';
                end
                
                fprintf('id: %g,\t target | prediction, class: %d | %d, score: %.1f | %.1f, prob: %.2f, %s\n', id, target_class, pred_class, score, pred_score, prob, true_false);
            end
        end
       
        function [ prob, pred_class ] = predictOneScenario(matData, Wxh, Whh, Why, bh, by)
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
                    [prob, pred_class] = max(Prob);
                end
            end
        end
   
    
         function class = score2class(score, score_max, score_min, n_output_classes )
            part = 1.0 / n_output_classes;
            pos = (score - score_min) / (score_max - score_min + 1e-8);
            pos_idx = floor(pos / part);
        % 	zs = zeros(n_output_classes, 1);
        % 	zs(pos_idx, 0) = 1;
        % 	return zs;
            class = pos_idx + 1;
         end

         function out = class2score(curClass, score_max, score_min, n_output_classes)
             % predicted class to score
             portion = (score_max - score_min) / n_output_classes;
             score_left = (curClass-1) * portion + score_min;
             score_right = (curClass) * portion + score_min;
             score = (score_left + score_right)/2;
%              fprintf('%d, %d, %d\n',score_left, score_right, score);
             score = vpa(score, 2);
             out = eval(score);
         end
          
     end
end

