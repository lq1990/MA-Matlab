function out = myInterp_tmp(data, factor )
    % my Interpolation by LinearSpline
    % since function interp1() in matlab is too slow, I write this m-file.
    % factor 扩展几倍，factor要大于1。上采样
    % 扩展方式：把两个相邻点间距，分成factor份。
    % 对于数据和time都可用。

    [n_rows, n_cols] = size(data);

    data_new = zeros(n_rows, n_cols); % init 列向量
    
    for i = 1:length(data)
        if i==1
            data_new(1) = data(1);
            continue
        end
        % 从第二个点开始
        
        i_new = (i-1)*factor +1;

        for j = 1:factor
            data_new(i_new-(factor-j)) = ( data(i)-data(i-1) ) / factor * j +data(i-1);
        end
    end
    
    out = data_new;
end
