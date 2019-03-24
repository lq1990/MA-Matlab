classdef ID124Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id124_start';
        m_id = 124;
        m_score = 6.7;
        m_details = 'Arteon, Start, Fp75'
        m_time_begin = 36533;
        m_time_end = 36953;
        m_kd = 0;
    end
    
    methods
        function thisid = ID124Start()
            disp('now id124...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID124Start;

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

