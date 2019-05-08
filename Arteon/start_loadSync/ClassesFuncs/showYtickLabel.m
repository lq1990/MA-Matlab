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
    xpos = ones(h, 1)+ size(data, 1) + offset; % ������ʾtext�� ypos
    text(xpos, ypos,...
            myyticklabel, ...
            'HorizontalAlignment', 'center', ...
            'rotation', 0,...
            'FontWeight', 'Bold'); % HorizontalAlignment ������ת�� right left center

end

