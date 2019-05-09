function showXtickLabel_tmp(data, signalT, offset)
    myxticklabel = {};
    for i = 1:height(signalT)
        signalName_cell = signalT.signalName(i);
        signalName = signalName_cell{1,1};
        myxticklabel = [myxticklabel, [num2str(i), ' ', signalName]];
    end

    set(gca, 'xticklabel', []);
    h = height(signalT);
    xpos = 1:h;
    ypos = ones(1, h)+ size(data, 1) + offset; % ������ʾtext�� ypos
    text(xpos, ypos,...
            myxticklabel, ...
            'HorizontalAlignment', 'center', ...
            'rotation', 70,...
            'FontWeight', 'Bold'); % HorizontalAlignment ������ת�� right left center
end

