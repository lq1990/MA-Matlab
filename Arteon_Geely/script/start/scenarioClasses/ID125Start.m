classdef ID125Start
    % ÿһ�����������Լ��� ���ԣ�������ֹʱ��
    
    properties(Constant = true)
        m_fieldname = 'id125_start';
        m_id = 125;
        m_score = 6.1;
        m_details = 'Arteon, Start, Fp100'
        m_time_begin = 41533;
        m_time_end = 41933;
        m_kd = 0;
    end
    
    methods
        function thisid = ID125Start()
            disp('now id125...')
        end
    end
    methods(Static = true)
        function myArteon_new = loadsave(file, myArteon_old)
            thisid = ID125Start;

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

