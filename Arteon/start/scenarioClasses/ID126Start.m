classdef ID126Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id126_start';
        m_id = 126;
        m_score = 6.6;
        m_details = 'Arteon, Start, KickDown'
        m_time_begin = 56133;
        m_time_end = 56483;
        m_kd = 1;
    end
    
    methods
        function thisid = ID126Start()
            disp('now id126...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID126Start;

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

