classdef ID121Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id121_start';
        m_id = 121;
        m_score = 8.9;
        m_details = 'Arteon, Start, Fp10'
        m_time_begin = 52403;
        m_time_end = 52613;
        m_kd = 0;
    end
    
    methods
        function thisid = ID121Start()
            disp('now id121...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID121Start;
            

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

