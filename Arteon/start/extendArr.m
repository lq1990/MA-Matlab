function newArr = extendArr( oldArr, num )
    % ��չ���飬����� 10x1 �� 100x1
    % ÿһ��Ԫ���ظ�nums��
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

