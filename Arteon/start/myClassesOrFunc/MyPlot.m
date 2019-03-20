classdef MyPlot
    
    methods
        function mp = MyPlot(myArr, aKP)
            MyPlot.plot(myArr, aKP);
        end
    end
    
   methods(Static = true, Access=private)     
       function [maxV, minV, amp] = findMaxMinOfScore(myArr)
           scoreList = [];
            for item = myArr
                scoreList = [scoreList, item.score] ;
            end

            maxV = max(scoreList);
            minV = min(scoreList);
            amp = 10;
       end

        function plot(myArr, aKP)
            figure;
            grid on; hold on;
            legendCell= {};
            
            [maxV, minV, amp] = MyPlot.findMaxMinOfScore(myArr);

            for item = myArr
                % 使用策略模式，避免 条件分支。由于matlab类似python 动态语言鸭子类型。
                [tmp_ylabel, tmp_title] = aKP.plot(item, maxV, minV, amp);
                
%                 if strcmp(tobeplot, 'ax')
%                     plot(item.ax, 'LineWidth',
%                     (item.score-minV)/(maxV-minV)*amp+0.1); tmp_ylabel =
%                     'm/s^2'; tmp_title = 'longitual accelaration';
%                 elseif strcmp(tobeplot,'engine_speed')
%                     plot(item.engine_speed, 'LineWidth',
%                     (item.score-minV)/(maxV-minV)*amp+0.1); tmp_ylabel =
%                     '1/min'; tmp_title = 'engine speed';
%                 elseif strcmp(tobeplot,'vehicle_speed')
%                     plot(item.vehicle_speed, 'LineWidth',
%                     (item.score-minV)/(maxV-minV)*amp+0.1); tmp_ylabel =
%                     'km/h'; tmp_title = 'vehicle speed';
%                 end
                
                tmpScoreStr = ['  score: ', num2str(item.score), ', ', item.details];
                legendCell = [legendCell, tmpScoreStr];
            end

            title(tmp_title); 
            legend(legendCell);
            ylabel(tmp_ylabel);
           
        end
    end
    
end

