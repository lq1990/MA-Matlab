function newArr = extendArr( oldArr, num )
    % 扩展数组，比如从 10x1 到 100x1
    % 每一个元素重复nums遍
    newArr = [];
    for i = 1: length(oldArr)
%         if i==length(oldArr)
%             newArr = [newArr; oldArr(i)];
%             continue
%         end
        for j= 1:num
            newArr = [newArr; oldArr(i)];
        end
    end
end

