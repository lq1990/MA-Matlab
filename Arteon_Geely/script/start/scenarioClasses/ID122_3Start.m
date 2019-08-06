classdef ID122_3Start
    % 每一个场景，有自己的 属性：测试起止时刻
    
    properties(Constant = true)
        m_fieldname = 'id122_3_start';
        m_id = 122.3;
        m_score = 7.9;
        m_details = 'Arteon, Start, Fp25'
        m_time_begin = 19500;
        m_time_end = 19800;
        m_kd = 0;
    end
    
    methods
        function thisid = ID122_3Start()
            disp('now id122.3...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID122_3Start;

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

