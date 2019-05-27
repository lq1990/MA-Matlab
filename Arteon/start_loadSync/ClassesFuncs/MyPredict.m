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
                matData = list_data(i).matDataZScore; % use matDataZScore

                [prob_list, pred_class_list]=MyPredict.predictOneScenario(matData, Wxh, Whh, Why, bh, by);
                pred_score_list = MyPredict.class2score(pred_class_list, maxScore, minScore, numClasses);
                
                if target_class == pred_class_list(1) % 和最大的prob比较
                    true_false = 'true';
                else
                    true_false = '---false---';
                end
                
                fprintf('id: %g,\t target | [pred1, pred2, pred3], class: %d | [%d, %d, %d], score: %.1f | [%.1f, %.1f, %.1f], prob: [%.2f, %.2f, %.2f], pred1: %s\n',...
                            id,  target_class, [pred_class_list(1),pred_class_list(2),pred_class_list(3)],...
                                            score, [pred_score_list(1), pred_score_list(2), pred_score_list(3)],...
                                                        [prob_list(1), prob_list(2), prob_list(3)],...
                                                        true_false);
            end
        end
       
        function [ prob_list, pred_class_list ] = predictOneScenario(matData, Wxh, Whh, Why, bh, by)
            % return the first three high prob and index
            % use FP and W b to predict scores
            H_ = zeros(length(Whh) ,1); % init H_
            for r = 1 : length(matData)
                curRow = matData(r, :)';

                Hraw = Wxh * curRow + Whh * H_ + bh;
                H = tanh(Hraw);
                H_ = H; % update H_

                if r == length(matData)
                    YModel = Why * H + by;
                    Prob = softmax(YModel); % column vector
                    [prob_list, pred_class_list] = MyUtil.findFirstThreeHighValAndIdx(Prob);
                    
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

