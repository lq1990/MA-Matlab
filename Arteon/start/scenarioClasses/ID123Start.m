classdef ID123Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id123_start';
        m_id = 123;
        m_score = 7.0;
        m_details = 'Arteon, Start, Fp50'
        m_time_begin = 21800;
        m_time_end = 22100;
        m_kd = 0;
    end
    
    methods
        function thisid = ID123Start()
            disp('now id123...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID123Start;
            
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

