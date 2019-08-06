function out = myInterp_tmp(data, factor )
    % my Interpolation by LinearSpline
    % since function interp1() in matlab is too slow, I write this m-file.
    % factor ��չ������factorҪ����1���ϲ���
    % ��չ��ʽ�����������ڵ��࣬�ֳ�factor�ݡ�
    % �������ݺ�time�����á�

    [n_rows, n_cols] = size(data);

    data_new = zeros(n_rows, n_cols); % init ������
    
    for i = 1:length(data)
        if i==1
            data_new(1) = data(1);
            continue
        end
        % �ӵڶ����㿪ʼ
        
        i_new = (i-1)*factor +1;

        for j = 1:factor
            data_new(i_new-(factor-j)) = ( data(i)-data(i-1) ) / factor * j +data(i-1);
        end
    end
    
    out = data_new;
end
