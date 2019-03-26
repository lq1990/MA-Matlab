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
        end
        
        function imData = import(kp)
            tmp = importdata(kp.m_fullpath);
            imData = tmp.data;
            
        end
        
        function fi = filter(kp)
            % Ay Òª±»¹ýÂË
        end
        
        function ex = extend(kp)
        end
        
        function pl = plot(kp, myArr)
        end
        
    end
    
end
