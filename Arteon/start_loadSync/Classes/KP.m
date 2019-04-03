classdef KP
    % KP Class, connect dir/filename. 
    % dir is from scenarioTable,  filename is from kpTable.
    % importdata
    properties
        m_kpname;
        m_filename;
        m_dir;
        m_fullpath;
    end
    
    methods
        function kp = KP(filename, dir)
%             kp.m_kpname = kpname;
            kp.m_filename = filename;
            kp.m_dir = dir;
            kp.m_fullpath = strcat(dir, '\', filename);
%             disp(kp.m_fullpath);
        end
        
        function imData = import(kp)
            tmp = importdata(kp.m_fullpath);
            imData = tmp.data;
        end
        
        function fiData = import_filter(kp, cut_off)
            imData = kp.import();
            % ¹ýÂË
            mf = MyFilter(imData, cut_off); % cut_off: 13 ~15 Hz
            fiData = mf.filter();
        end
        
        function ex = extend(kp)
        end
        
        function pl = plot(kp, myArr)
        end
        
    end
    
end
