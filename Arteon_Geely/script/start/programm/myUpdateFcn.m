function txt = myUpdateFcn(empt, eventdata)
pos = get(eventdata, 'Position');
txt = {['Time: ',num2str(pos(1), '%5.6f')],...
	      ['Amplitude: ', num2str(pos(2), '%5.6f')]};