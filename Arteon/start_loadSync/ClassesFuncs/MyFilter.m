classdef MyFilter
    properties
        m_srcdata;
        m_cut_off; % 13 ~ 15
        m_order = 8; % may regulate with the cut_off
    end
    
    methods
        function mf = MyFilter(srcdata, cut_off)
            mf.m_srcdata = srcdata;
            mf.m_cut_off = cut_off;
        end
        
        
        function outdata = filter(mf, ifplot)
            srcdata = mf.m_srcdata;
            len = length(srcdata);
            t = 1:len;

            nfft = length(srcdata);
            nfft2 = 2.^nextpow2(nfft);
            fy = fft(srcdata, nfft2);
            fy =fy(1: nfft2/2);
            Fs = 100; % ²ÉÑùÆµÂÊ
            xfft = Fs.*(0: nfft2/2 -1) / nfft2;

            % filer
            cut_off = mf.m_cut_off / Fs/2; % cut_off frequency
            order = mf.m_order;
            h = fir1(order, cut_off);

            fh = fft(h, nfft2);
            fh = fh(1: nfft2/2);

            con = conv(srcdata, h);
            outdata = con(1+order/2: end-order/2);
            
            foutdata = fft(outdata, nfft2);
            foutdata = foutdata(1:nfft2/2);
            
            if nargin==2 && ifplot==true
                figure(101);
                subplot(2, 3, 1)
                plot(t, srcdata); grid on;
                title('original time domain');

                subplot(2, 3, 2);
                plot(xfft, abs(fy/max(fy))); grid on;
                title('original frequency domain');

                subplot(2, 3, 6)
                plot(xfft, abs(fh/max(fh))); grid on;
                xlabel('Hz');
                title('filter');

                subplot(2, 3, 4);
                plot(t, outdata); grid on;
                title('after filtering, time domain');
                
                subplot(2,3,5)
                plot(xfft, abs(foutdata/max(foutdata))); grid on;
                title('after filtering, freq domain');
                
            end
            
            
        end
    end
    
end
