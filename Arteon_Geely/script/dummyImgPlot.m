
param_str = '';
data = [0.7, -0.2; -0.5, 0.3];
ifaxisequal = 1;
titleStr = 'Matrix';

MyPlot.showMatrix(param_str, data,  ifaxisequal, titleStr);
xlabel('column');
ylabel('row');
set(gca, 'FontSize', 12);
set(gca,'fontweight','bold');


