function showYtickLabel(data, signalT, offset)
%SHOWXTICKLABEL Summary of this function goes here
%   Detailed explanation goes here

    myyticklabel = {};
    for i = 1:height(signalT)
        signalName_cell = signalT.signalName(i);
        signalName = signalName_cell{1,1};
        myyticklabel = [myyticklabel, [num2str(i), ' ', signalName]];
    end

    set(gca, 'yticklabel', []);
    h = height(signalT);
    ypos = 1:h;
    xpos = ones(h, 1)+ size(data, 1) + offset; % 设置显示text的 ypos
    text(xpos, ypos,...
            myyticklabel, ...
            'HorizontalAlignment', 'center', ...
            'rotation', 0,...
            'FontWeight', 'Bold'); % HorizontalAlignment 设置旋转轴 right left center

end

