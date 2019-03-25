classdef KP
    properties
        m_kpname;
        m_filename;
        m_dir;
        m_fullpath;
    end
    
    methods
        function kp = KP(kpname, filename, dir)
            kp.m_kpname = kpname;
            kp.m_filename = filename;
            kp.m_dir = dir;
            kp.m_fullpath = strcat(dir, '\', filename);
        end
        
        function imData = import(kp)
            tmp = importdata(kp.m_fullpath);
            imData = tmp.data;
            
        end
        
        function fi = filter(kp)
        end
        
        function ex = extend(kp)
        end
        
        function pl = plot(kp, myArr)
        end
        
    end
    
end
