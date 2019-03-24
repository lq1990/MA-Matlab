classdef ID122_2Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id122_2_start';
        m_id = 122.2;
        m_score = 8.2;
        m_details = 'Arteon, Start, Fp25'
        m_time_begin = 15900;
        m_time_end = 16300;
        m_kd = 0;
    end
    
    methods
        function thisid = ID122_2Start()
            disp('now id122.2...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID122_2Start;
            
            sf = MySetField(file,...
                thisid.m_fieldname,...
                thisid.m_id,...
                thisid.m_score,...
                thisid.m_details,...
                thisid.m_time_begin,...
                thisid.m_time_end,...
                thisid.m_kd);
            myArteon_new = sf.sf_loadsave(myArteon_old);

        end
    end
    
end

